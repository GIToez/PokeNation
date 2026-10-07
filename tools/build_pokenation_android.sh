#!/usr/bin/env bash
# Build the PokeNation Android APK from the same client-pokenation/ source tree (no fork).
#   tools/build_pokenation_android.sh
#   OTCLIENT_ANDROID_ABIS=arm64-v8a (default; comma list: arm64-v8a,armeabi-v7a,x86_64,x86)
# Needs: JDK 17, Android SDK with NDK 29.0.13599879 and CMake 3.22.1 (ANDROID_HOME/ANDROID_SDK_ROOT,
# ANDROID_NDK_HOME), VCPKG_ROOT (bootstrapped at the client-pokenation/vcpkg.json baseline).
# Output: build/client-pokenation/android/PokeNation-Android.apk
# Gradle keeps its own intermediates under client-pokenation/android/app/build (git-ignored).
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/dev_env.sh"

SRC="$ROOT_DIR/client-pokenation"
OUT="$ROOT_DIR/build/client-pokenation/android"
export OTCLIENT_ANDROID_ABIS="${OTCLIENT_ANDROID_ABIS:-arm64-v8a}"
LUAJIT_COMMIT=d0e88930ddde28ff662503f9f20facf34f7265aa   # upstream's pinned LuaJIT (vcpkg-compatible)

export ANDROID_HOME="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-}}"
[ -n "$ANDROID_HOME" ] || die "ANDROID_HOME (or ANDROID_SDK_ROOT) must point to the Android SDK"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANDROID_NDK_HOME="${ANDROID_NDK_HOME:-$ANDROID_HOME/ndk/29.0.13599879}"
[ -d "$ANDROID_NDK_HOME" ] || die "Android NDK not found at $ANDROID_NDK_HOME (sdkmanager \"ndk;29.0.13599879\")"
[ -n "${VCPKG_ROOT:-}" ] && [ -x "$VCPKG_ROOT/vcpkg" ] || die "VCPKG_ROOT must point to a bootstrapped vcpkg"
command -v java >/dev/null || die "JDK 17 is required"

mkdir -p "$OUT"

if [ ! -f "$SRC/android/app/libs/lib/${OTCLIENT_ANDROID_ABIS%%,*}/libluajit-5.1.a" ]; then
  say "Building LuaJIT $LUAJIT_COMMIT for $OTCLIENT_ANDROID_ABIS"
  if [ ! -d "$SRC/luajit-src/.git" ]; then
    git clone -q https://github.com/LuaJIT/LuaJIT.git "$SRC/luajit-src" || die "cannot clone LuaJIT"
  fi
  git -C "$SRC/luajit-src" checkout -q "$LUAJIT_COMMIT" || die "cannot check out LuaJIT $LUAJIT_COMMIT"
  bash "$SRC/build_luajit_android.sh" || die "LuaJIT Android build failed"
fi

say "Packing game data into android/app/src/main/assets/data.zip"
python3 "$ROOT_DIR/tools/pack_pokenation_data.py" --android "$SRC/android/app/src/main/assets/data.zip" \
  || die "packing data.zip failed"

# Unsigned production keys never live in the repository. Without RELEASE_KEYSTORE the APK is
# signed with the local Android debug keystore (created here if missing): development use only.
if [ -z "${RELEASE_KEYSTORE:-}" ] && [ ! -f "$HOME/.android/debug.keystore" ]; then
  say "Creating a local Android debug keystore (~/.android/debug.keystore)"
  mkdir -p "$HOME/.android"
  keytool -genkeypair -keystore "$HOME/.android/debug.keystore" -storepass android -keypass android \
    -alias androiddebugkey -keyalg RSA -keysize 2048 -validity 10000 \
    -dname "CN=Android Debug,O=Android,C=US" >/dev/null || die "keytool failed"
fi

say "Building the APK with Gradle"
(cd "$SRC/android" && chmod +x gradlew && ./gradlew :app:assembleRelease --no-daemon --stacktrace) \
  || die "Gradle build failed"

APK="$(find "$SRC/android/app/build/outputs/apk/release" -maxdepth 1 -name '*.apk' | head -n1)"
[ -n "$APK" ] || die "Gradle finished but produced no APK"
cp "$APK" "$OUT/PokeNation-Android.apk"
say "APK: ${OUT#$ROOT_DIR/}/PokeNation-Android.apk ($(du -h "$OUT/PokeNation-Android.apk" | cut -f1))"
