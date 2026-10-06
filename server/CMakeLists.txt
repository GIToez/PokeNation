# PSoul / PokeAimar game server (TFS 0.3.x lineage) — Linux build.
#
# The archive only shipped a Dev-C++/MinGW Makefile (src/dev-cpp/Makefile.win) and an
# autotools skeleton (src/configure.ac, src/Makefile.am). This CMake file reproduces the
# Makefile.win configuration as closely as possible on a modern toolchain:
#   defines : -D__USE_MYSQL__ -D__USE_SQLITE__ -D__ENABLE_SERVER_DIAGNOSTIC__ -D__EMERGENCY_SAVE__ -D__CONSOLE__
#   libs    : boost (system, filesystem, thread, regex), lua5.1, mysqlclient, sqlite3, libxml2, gmp, crypto
# __EXCEPTION_TRACER__ is Windows/MinGW specific (uses tlhelp32/excpt) and is therefore not enabled here.
cmake_minimum_required(VERSION 3.16)
project(psoul-server CXX)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Build type" FORCE)
endif()

option(SERVER_DIAGNOSTIC "Enable __ENABLE_SERVER_DIAGNOSTIC__ (object counters, as in the original Makefile.win)" ON)
option(ROOT_PERMISSION   "Allow running the server as root (__ROOT_PERMISSION__)" ON)

find_package(Boost 1.55 REQUIRED COMPONENTS system filesystem thread regex)
find_package(Threads REQUIRED)
find_package(LibXml2 REQUIRED)
find_package(OpenSSL REQUIRED)
find_package(PkgConfig REQUIRED)
pkg_check_modules(LUA REQUIRED IMPORTED_TARGET lua5.1)
pkg_check_modules(SQLITE3 REQUIRED IMPORTED_TARGET sqlite3)

# MySQL / MariaDB client library
find_program(MYSQL_CONFIG NAMES mysql_config mariadb_config)
if(MYSQL_CONFIG)
  execute_process(COMMAND ${MYSQL_CONFIG} --cflags OUTPUT_VARIABLE MYSQL_CFLAGS OUTPUT_STRIP_TRAILING_WHITESPACE)
  execute_process(COMMAND ${MYSQL_CONFIG} --libs   OUTPUT_VARIABLE MYSQL_LIBS   OUTPUT_STRIP_TRAILING_WHITESPACE)
  separate_arguments(MYSQL_CFLAGS)
  separate_arguments(MYSQL_LIBS)
else()
  find_path(MYSQL_INCLUDE_DIR mysql.h PATH_SUFFIXES mysql mariadb)
  find_library(MYSQL_LIBRARY NAMES mysqlclient mariadbclient mariadb)
  set(MYSQL_CFLAGS "-I${MYSQL_INCLUDE_DIR}")
  set(MYSQL_LIBS "${MYSQL_LIBRARY}")
endif()

find_library(GMP_LIBRARY NAMES gmp REQUIRED)
find_path(GMP_INCLUDE_DIR gmp.h REQUIRED)

# Source list mirrors src/dev-cpp/Makefile.win (gui.cpp / inputbox.cpp / exception.cpp are kept:
# their bodies are guarded by WINDOWS / __EXCEPTION_TRACER__ and compile to nothing here).
set(SRC_DIR ${CMAKE_CURRENT_SOURCE_DIR}/src)
set(SERVER_SOURCES
  actions.cpp allocator.cpp baseevents.cpp beds.cpp chat.cpp combat.cpp protocolold.cpp condition.cpp
  configmanager.cpp connection.cpp container.cpp creature.cpp creatureevent.cpp cylinder.cpp database.cpp
  databasemysql.cpp databasesqlite.cpp depot.cpp exception.cpp fileloader.cpp game.cpp gui.cpp house.cpp
  housetile.cpp inputbox.cpp ioguild.cpp iologindata.cpp iomap.cpp iomapserialize.cpp item.cpp items.cpp
  luascript.cpp mailbox.cpp map.cpp md5.cpp monster.cpp monsters.cpp movement.cpp networkmessage.cpp npc.cpp
  otserv.cpp outfit.cpp outputmessage.cpp party.cpp player.cpp playerbox.cpp position.cpp protocol.cpp
  protocolgame.cpp protocollogin.cpp quests.cpp raids.cpp rsa.cpp scheduler.cpp scriptmanager.cpp server.cpp
  sha1.cpp spawn.cpp spells.cpp status.cpp talkaction.cpp tasks.cpp teleport.cpp textlogger.cpp thing.cpp
  tile.cpp tools.cpp trashholder.cpp vocation.cpp waitlist.cpp weapons.cpp ioban.cpp globalevent.cpp
  gameservers.cpp databasemanager.cpp admin.cpp itemattributes.cpp group.cpp partyduel.cpp pvparena.cpp
  tournament.cpp iotournament.cpp iodatalog.cpp ioplayerstatistics.cpp iomarket.cpp polls.cpp iopoll.cpp
  localization.cpp
)
list(TRANSFORM SERVER_SOURCES PREPEND ${SRC_DIR}/)

add_executable(psoul-server ${SERVER_SOURCES})

target_compile_definitions(psoul-server PRIVATE
  __USE_MYSQL__ __USE_SQLITE__ __EMERGENCY_SAVE__ __CONSOLE__
  _THREAD_SAFE _REENTRANT
)
if(SERVER_DIAGNOSTIC)
  target_compile_definitions(psoul-server PRIVATE __ENABLE_SERVER_DIAGNOSTIC__)
endif()
if(ROOT_PERMISSION)
  target_compile_definitions(psoul-server PRIVATE __ROOT_PERMISSION__)
endif()

target_include_directories(psoul-server PRIVATE ${SRC_DIR} ${GMP_INCLUDE_DIR})
target_compile_options(psoul-server PRIVATE ${MYSQL_CFLAGS} -Wall -Wno-unused-variable -Wno-unused-but-set-variable)

target_link_libraries(psoul-server PRIVATE
  Boost::system Boost::filesystem Boost::thread Boost::regex
  Threads::Threads
  LibXml2::LibXml2
  OpenSSL::Crypto
  PkgConfig::LUA
  PkgConfig::SQLITE3
  ${MYSQL_LIBS}
  ${GMP_LIBRARY}
)

if(WIN32)
  # MinGW-w64 (MSYS2) build, as used by .github/workflows/build.yml. Makefile.win linked
  # wsock32/ws2_32; Boost.Asio additionally needs mswsock.
  target_link_libraries(psoul-server PRIVATE ws2_32 mswsock)
  target_compile_definitions(psoul-server PRIVATE _WIN32_WINNT=0x0601)
endif()

set_target_properties(psoul-server PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
)
