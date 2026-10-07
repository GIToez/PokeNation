local MALE_NAMES = {"Randall","Wilbert","Houston","Fernando","Perry","Percy","Jerrod","Everette","Emilio","Denis","Rubin","Ross","Raul","Lupe","Gerardo","Ignacio","Dante","Joel","Tracy","Jules","Florentino","Cedrick","Alex","Ike","Elroy","Numbers","Judson","Arnold","Rob","Bennie","Roman","Arlen","Gregg","Les","Elliott","Leo","Felix","Leonardo","Deon","Charles","Brandon","Milford","Aurelio","Hershel","Grover","Byron","Larry","Emory","Mario","Rodrigo","Clayton","Steven","Frankie","Scott","Asa","Timmy","Johnathan","Chong","Shawn","Alfonzo","Cedrick","Nathanial","Ray","Devin","Bernardo","Charlie","Riley","Carter","Chet","Clinton","Mohammed","Jacques","Ambrose","Alvin","Lee","Hans","Bobbie","Lonny","Numbers","Jame","Emerson","Genaro","Jerald","Mitchel","Bret","Brendon","Edmond","Robbie","Isaias","Tracey","Terry","Darell","Quincy","Christopher","Alfredo","Frederick","Lamar","Moses","Reginald","Raphael","Alden","Elmer","Octavio","Thurman","Carlton","Wyatt","Antonia","Carol","Rudolph","Barrett","Micah","Mickey","Reginald","Wally","Clyde","Wallace","Arlen","Mathew","Brendan","Burt","Ismael","Mel","Randy","Chi","Jame","Sammy","Myron","Dusty","Arnulfo","Robbie","Ronald","Perry","Seth","Weston","Armand","Jae","Alejandro","Will","Bill","Shane","Jayson","Bert","Nathanial","Ahmed","Broderick","Silas","Dante","Frederick","Huey","Eduardo","Ronny","Kurtis","Omar","Bert","Samuel","Rocco","Hyman","Jordan","Rick","Dewitt","Clay","Roland","Alfredo","Rod","Antione","Rolando","Timmy","Dana","Marcellus","Tory","Connie","Kris","Leonel","Ferdinand","John","Emmanuel","Dillon","Andrew","Richie","Major","Chris","Garfield","Rayford","Jefferey","Cyril","Galen","Waldo","Robt","Leon","Dino","Cary","Kenneth","Randall","Willard","Taylor","Francisco","Phillip","Claude","Ricky","Vicente","Paris","Clarence","Guy","Fabian","Leif","Kristofer","Wyatt","Hyman","Gaston","Houston","Gabriel","Wm","Branden","Eli","Valentine","Tracy","Perry","Lloyd","Asa","Jerold","Brett","Kenny","Olin","Freddie","Moises","Quinn","Rolando","Brain","Terrence","Mauricio","Stewart","Vern","Irvin","Jonah","Gerald","Bobbie","Jody","Ollie","Elisha","Donn","Benedict","Alex","Daren","Lorenzo","Josiah","Benito","Kent","Kirby","Edwardo","Don"}
local FEMALE_NAMES = {"Caitlyn","Franchesca","Colene","Shameka","Joline","Enda","Kiara","Ashlyn","Roselyn","Manuela","Freda","Mariko","Alma","Kirstin","Shanell","Adaline","Kiersten","Marcella","Lilli","Sherly","Shelli","Kiana","Silvana","Mirian","Fae","Tiffaney","Lucinda","Odelia","Sherrill","Yesenia","Sharmaine","Nickole","Rebeca","Mari","Hilary","Donna","Debbi","Theodora","Edris","Ignacia","Colette","Mariah","Lekisha","Kala","Su","Shirl","Liz","Karyn","Ossie","Barbara","Deandrea","Genia","Yevette","Liliana","Latoya","Jamika","Saundra","Rosalba","Nicole","Shavonda","Annalisa","Candyce","Evia","Deedra","Chantal","Annelle","Hildegard","Narcisa","Larissa","Lisa","Felica","Kasie","Sally","Shiloh","Cecelia","Etsuko","Reita","Eusebia","Brittani","Samella","Melissa","Elenor","Lashawn","Tora","Geralyn","Mitzi","Marilyn","Fabiola","Rose","Maragret","Vernetta","Carmina","Valery","Yolanda","Maile","Shizuko","Cordia","Vinnie","Letisha","Nellie","Mariana","Jonelle","Cristy","Daisey","Shanae","Sanjuanita","Kitty","Meaghan","Jeraldine","Nelle","Katrina","Gwendolyn","Jillian","Annita","Jeane","Shawna","Etsuko","Cherly","Evie","Valda","Ramona","Karlene","Sherri","Christi","Ora","Georgette","Lavelle","Leontine","Rachael","Almeta","Jenny","Treasa","Randee","Bong","Georgiann","Audra","Josefa","Buena","Reena","Loretta","Renetta","Novella","Marti","Shan","Belva","Melissa","Alison","Santana","Thuy","Deandrea","Tawana","Devona","Ana","Tiny","Bronwyn","Myrtie","Janise","Donita","Mignon","Viva","Fredda","Jennifer","Brittanie","Twyla","Brunilda","Hiedi","Florrie","Robena","Taren","Dani","Carly","Farrah","Seema","Felica","Christen","Gay","Candelaria","Tamica","Tajuana","Mona","Micheline","Chun","Jeni","Autumn","Sima","Berna","Emelia","Veola","Patty","Romana","Alice","Alejandra","Miriam","Shenita","Magan","Cuc","Lupita","Robyn","Marjory","Shira","Vashti","Julia","Kasie","Kala","Jacqulyn","Kenisha","Florida","Akilah","Kiera","Bailey","Aundrea","Rosina","Lacie","Lashanda","Bonnie","Theresa","Maegan","Lu","Nohemi","Deb","Sebrina","Venessa","Twyla","Malena","Carlita","Vasiliki","Joie","Gertrud","Toshiko","Antionette","Marcell","Casandra","Yoshie","Ashton","Dulcie","Clemencia","Danica","Agnus","Mozelle","Tressa","Zelma","Miss","Scarlett","Maybell","Shana","Meg","Eilene","Gudrun","Nichole","Josephine"}
local LAST_NAMES = {"Lambe","Gerrior","Mathieu","Bortvin","Terres","Howey","Dulawan","Levkoff","Jaeger","Casco","Dietz","Donner-corbello","Towler","Risher","Deegan","Chiassino","Zimmermann-huisgen","Clasen","Fulgham","Kruskal","Locke","Curtin","Holdrege","Dostoievski","Dowsland","Ronen","Feinstein","Everette","Yokoe","Broom","Chiodi","Serageldin","Dai","Dermody","Colen","Dunlop","Carpenter","Fargo","Vancil","Svedrofsky","Chua","Sussman","Rhode","Cormier","Henebury","Whitney","Throop","Greenstein","Le guin","Jaynes","Bolman","Kolter","Zeitlin","Skovgaard","Cocchi","Cronshaw","Kaplow","Bednarek","Hottle","Brecht","Rodenberg","Whittaker","Schwarz","Sethuraman","Ma","Lucey","Ravera","Lincoln","Trungpa","Bradbury","Gong","Brockett","Gay","Maher","Oeun","Vaillant","Drain","Cornet","Centrella","Gide","Kubovy","Helprin","Shepherd","Grenon","Neveu","Drudi","Kuijken","Christenson","Macgibbon","Holtzman","Enyeart","Mak"}
local POSITIONS = {{x = 3281, y = 819, z = 7}, {x = 3311, y = 823, z = 7}, {x = 3294, y = 799, z = 7}, {x = 3339, y = 823, z = 6}, {x = 3300, y = 605, z = 7}, {x = 3313, y = 583, z = 7}, {x = 3284, y = 569, z = 7}, {x = 3275, y = 594, z = 7}, {x = 3249, y = 576, z = 7}, {x = 3296, y = 539, z = 7}, {x = 3298, y = 332, z = 7}, {x = 3276, y = 307, z = 7}, {x = 3291, y = 281, z = 7}, {x = 3333, y = 290, z = 7}, {x = 3307, y = 264, z = 7}, {x = 3265, y = 259, z = 7}, {x = 3851, y = 287, z = 7}, {x = 3914, y = 276, z = 7}, {x = 3906, y = 327, z = 7}, {x = 3932, y = 266, z = 7}, {x = 3919, y = 252, z = 7}, {x = 3855, y = 320, z = 7}, {x = 3909, y = 487, z = 7}, {x = 3919, y = 459, z = 7}, {x = 3975, y = 473, z = 7}, {x = 3938, y = 513, z = 7}, {x = 3993, y = 476, z = 7}, {x = 3666, y = 454, z = 7}, {x = 3648, y = 438, z = 7}, {x = 3664, y = 416, z = 7}, {x = 3707, y = 468, z = 7}, {x = 3667, y = 461, z = 7}, {x = 4160, y = 567, z = 7}, {x = 4202, y = 556, z = 7}, {x = 4201, y = 588, z = 7}, {x = 4178, y = 558, z = 7}, {x = 3912, y = 647, z = 7}, {x = 3956, y = 616, z = 7}, {x = 3984, y = 646, z = 7}, {x = 3910, y = 615, z = 7}, {x = 3880, y = 873, z = 7}, {x = 3856, y = 855, z = 7}, {x = 3835, y = 827, z = 7}, {x = 3876, y = 820, z = 7}, {x = 3919, y = 814, z = 7}, {x = 3871, y = 843, z = 7}, {x = 3449, y = 1476, z = 7}, {x = 3473, y = 1473, z = 7}, {x = 3530, y = 1513, z = 7}, {x = 3423, y = 1509, z = 7}, {x = 3508, y = 1713, z = 7}, {x = 3570, y = 1698, z = 7}, {x = 3552, y = 1675, z = 7}, {x = 3056, y = 1705, z = 7}, {x = 3087, y = 1696, z = 7}, {x = 3051, y = 1680, z = 7}, {x = 2943, y = 2247, z = 7}, {x = 2963, y = 2270, z = 7}, {x = 2978, y = 2236, z = 7}, {x = 4384, y = 2702, z = 7}, {x = 4374, y = 2685, z = 7}, {x = 4171, y = 2965, z = 7}, {x = 4203, y = 2932, z = 7}, {x = 3603, y = 3317, z = 7}, {x = 3596, y = 3169, z = 7}, {x = 3478, y = 3231, z = 6}, {x = 2754, y = 2836, z = 6}, {x = 2757, y = 2827, z = 5}, {x = 3254, y = 2776, z = 6}}
local FEMALE_OUTFITS = {1210, 1207, 1202, 1200, 1198, 1196, 1194, 1192, 1190, 1188, 1186, 1184, 1182, 1180, 635, 633, 631, 629, 627, 625, 623, 621, 617, 615, 613, 611}
local MALE_OUTFITS = {1209, 1206, 1203, 1201, 1199, 1197, 1195, 1193, 1191, 1189, 1187, 1185, 1183, 1181, 636, 634, 632, 630, 628, 626, 624, 622, 618, 616, 614, 612}
local GREETS = {"Hello!","I'm raising POKEMON too! When they get strong, they can protect me!","Technology is incredible! You can now store and recall items and POKEMON as data via PC!", "PROF.OAK is the authority on POKEMON! Many POKEMON trainers hold him in high regard!","The battle moves of POKEMON are limited by their ENERGY. To replenish ENERGY, feed your POKEMON or give him an ENERGY POTION!","Those POKE BALLS at your waist! You have POKEMON! It's great that you can carry and use POKEMON any time, anywhere!","CATERPIE has no poison, but WEEDLE does. Watch out for its POISON STING!","Yawn! I must have dozed off in the sun. I had this dream about a DROWZEE eating my dream.","There's a POKEMON CENTER in every town ahead. They don't charge any money either!","POKEMON CENTERS heal your tired, hurt or fainted POKEMON!","Coming up with nicknames is fun, but hard. Simple names are the easiest to remember.","My Daddy loves POKEMON too.","When I go shop in PEWTER CITY, I have to take the winding trail in VIRIDIAN FOREST.","Ahh, I've had my coffee now and I feel great! Sure you can go through!","Catch POKEMON and expand your collection! The more you have, the easier it is to fight!","RATTATA may be small, but its bite is wicked!","I came here with some friends! They're out for POKEMON fights!","I ran out of POKE BALLs to catch POKEMON with! You should carry extras!","No stealing of POKEMON from other trainers! Catch only wild POKEMON!","Have you noticed the bushes on the roadside? They can be cut down by a special POKEMON move.","Many POKEMON live only in forests and caves. You need to look everywhere to get different kinds!","There aren't many serious POKEMON trainers here!","Yawn! When JIGGLYPUFF sings, POKEMON get drowsy... ...Me too... Snore...","Good things can happen if you raise POKEMON diligently, even the weak ones!","A shady, old man got me to buy this really weird fish POKEMON!","POKEMON learn new techniques as they grow! But, some moves must be taught by the trainer!","July 20, 1969! The 1st lunar landing! I bought a color TV to watch it!","I want a PIKACHU! It's so cute!","I've 6 POKE BALLS set in my belt. At most, you can carry 6 POKEMON.","It's so hard to control POKEMON! Your POKEMON's obedience depends on your abilities as a trainer!","You're a trainer too? Collecting, fighting, it's a tough life.","Have you heard about BILL? Everyone calls him a POKEMANIAC! I think people are just jealous of BILL, though. Who wouldn't want to boast about their POKEMON?","Have you seen any RARE CANDY? It's supposed to make POKEMON go up one level!","POKEMON BADGES are owned only by skilled trainers. I see you have at least one. Those BADGEs have amazing secrets!","Yo! Champ in making! Here's my advice! The LEADER, MISTY, is a pro who uses water POKEMON! You can drain all their water with plant POKEMON! Or, zap them with electricity!","It is true that a higher level POKEMON will be more powerful... But, all POKEMON will have weak points against specific types. So, there is no universally strong POKEMON.","My POKEMON was poisoned! It fainted while we were walking!","Even if they are the same level, POKEMON can have very different abilities. A POKEMON raised by a trainer is stronger than one in the wild.","There are evil people who will use POKEMON for criminal acts. TEAM ROCKET traffics in rare POKEMON. They also abandon POKEMON that they consider not to be popular or useful.","I think POKEMON can be good or evil. It depends on the trainer.","I'm the FISHING GURU! I simply Looove fishing!","If someone brags, brag right back!","S.S.ANNE is a famous luxury cruise ship. We visit VERMILION once a year.","Have you gone to the SAFARI ZONE in FUCHSIA CITY? It had many rare kinds of POKEMON!!","I heard that GHOSTs haunt LAVENDER TOWN!","The element types of POKEMON make them stronger than some types and weaker than others!","For long outings, you should buy REVIVE.","Oh, hi! I finally finished POKEMON! Not done yet? This might be useful!","All right! My buddy's going to trade me his KANGASKHAN for my GRAVELER!","I'm getting a POKE DOLL for my friend!","My sister is a trainer, believe it or not. But, she's so immature, she drives me nuts!","I'm having a wonderful time!","New GREAT BALL offers improved capture rates. Try it on those hard-to-catch POKEMON.","REVIVE is costly, but it revives fainted POKEMON!","POKEMON LAB created PORYGON, the first virtual reality POKEMON.","You need to use TMs to teach good moves to POKEMON!","If you're studying POKEMON, visit the SAFARI ZONE. It has all sorts of rare POKEMON.","You can't win with just one strong POKEMON. It's tough, but you have to raise them evenly.","I'm catching POKEMON to take home as gifts!","My EEVEE evolving into FLAREON! But, a friend's EEVEE turned into a VAPOREON! I wonder why?","Do you have any friends? POKEMON you get in trades grow very quickly. I think it's worth a try!","It never hurts to have extra items!"}
local FAREWELLS = {"Bye!"}
local MALE_CITIZENS = 30
local FEMALE_CITIZENS = 30
local FILE_PREFIX = "tmpCitizen_"
local PET_CHANCE = 30 -- 1 - 100
local FORBIDDEN_POKEMON = {"Unown", "Aerodactyl", "Articuno", "Zapdos", "Moltres", "Mewtwo", "Mew",
    "Raikou", "Entei", "Suicune", "Lugia", "Ho-Oh", "Celebi", "Shiny Aerodactyl",
    "Shiny Articuno", "Shiny Zapdos", "Shiny Moltres", "Shiny Mewtwo", "Shiny Mew",
    "Shiny Raikou", "Shiny Entei", "Shiny Suicune", "Shiny Lugia", "Shiny Ho-Oh", "Shiny Celebi",
    "Regice", "Registeel", "Regirock", "Latias", "Latios", "Groudon", "Kyogre", "Rayquaza", "Jirachi", "Deoxys"}

-- TODO: Check run - yes they are free at the world

local tmpPositions = table.copy(POSITIONS)
local function generatePosition()
    if (#tmpPositions == 0) then
        tmpPositions = table.copy(POSITIONS)
        return table.random(POSITIONS)
    end

    local pos = table.random(tmpPositions)
    if (not pos) then
        tmpPositions = table.copy(POSITIONS)
        return table.random(POSITIONS)
    end

    local p = table.find(tmpPositions, pos)
    if (p) then
        table.remove(tmpPositions, p)
    end

    return pos
end

local tmpGreets = table.copy(GREETS)
local function generateGreet()
    if (#tmpGreets == 0) then
        tmpGreets = table.copy(GREETS)
        return table.random(GREETS)
    end

    local greet = table.random(tmpGreets)
    if (not greet) then
        tmpGreets = table.copy(GREETS)
        return table.random(GREETS)
    end

    local p = table.find(tmpGreets, greet)
    if (p) then
        table.remove(tmpGreets, p)
    end

    return greet
end

local function createNpcFile(fileName, content)
    local path = string.concat(getDataDir(), "/npc/", fileName, ".xml")
    local f = io.open(path, "w+")
    if (not f) then
        log(LOG_TYPES.ERROR, "createNpcFile - Can\'t create file", path, fileName, content)
        return false
    end

    f:write(content)
    f:close()
    return true
end

local function createNpc(fileName, position, parameters)
    local out = {}
    out[1] = "<?xml version=\"1.0\"?><npc "

    if (parameters.name) then
        out[#out + 1] = "name=\""
        out[#out + 1] = parameters.name
        out[#out + 1] = "\" "
    end

    if (parameters.floorchange) then
        out[#out + 1] = "floorchange=\""
        out[#out + 1] = parameters.floorchange
        out[#out + 1] = "\" "
    end

    if (parameters.walkinterval) then
        out[#out + 1] = "walkinterval=\""
        out[#out + 1] = parameters.walkinterval
        out[#out + 1] = "\""
    end

    out[#out + 1] = ">"

    if (parameters.health) then
        out[#out + 1] = "<health now=\""
        out[#out + 1] = parameters.health
        out[#out + 1] = "\" max=\""
        out[#out + 1] = parameters.health
        out[#out + 1] = "\"/> "
    end

    if (parameters.look) then
        out[#out + 1] = "<look type=\""
        out[#out + 1] = parameters.look.type
        out[#out + 1] = "\" head=\""
        out[#out + 1] = parameters.look.head
        out[#out + 1] = "\" body=\""
        out[#out + 1] = parameters.look.body
        out[#out + 1] = "\" legs=\""
        out[#out + 1] = parameters.look.legs
        out[#out + 1] = "\" feet=\""
        out[#out + 1] = parameters.look.feet
        out[#out + 1] = "\" addons=\""
        out[#out + 1] = parameters.look.addons
        out[#out + 1] = "\"/> "
    end

    if (parameters.interactions) then
        out[#out + 1] = "<interaction range=\"3\" idletime=\"60\">"

        out[#out + 1] = "<interact keywords=\"hi\" focus=\"1\"><keywords>hello</keywords><keywords>oi</keywords><keywords>ola</keywords><response text=\""
        out[#out + 1] = parameters.interactions.greet
        out[#out + 1] = "\"><action name=\"idle\" value=\"1\"/></response></interact>"


        out[#out + 1] = "<interact keywords=\"bye\" focus=\"0\"><keywords>farewell</keywords><response text=\""
        out[#out + 1] = parameters.interactions.farewell
        out[#out + 1] = "\"/></interact></interaction>"
    end

    if (parameters.voices and #parameters.voices > 0) then
        out[#out + 1] = "<voices>"

        for k, v in pairs (parameters.voices) do
            out[#out + 1] = "<voice text=\""
            out[#out + 1] = v.text
            out[#out + 1] = "\" interval2=\""
            out[#out + 1] = v.interval
            out[#out + 1] = "\" margin=\""
            out[#out + 1] = v.margin
            out[#out + 1] = "\"/>"
        end

        out[#out + 1] = "</voices>"
    end

    out[#out + 1]  = "</npc>"

    if (createNpcFile(fileName, tostring(table.concat(out)))) then
        local npc = doCreateNpc(fileName, position)
        if (not npc or not isCreature(npc)) then
            log(LOG_TYPES.ERROR, "Citizens::createNpc - Can't create NPC.", fileName, out, position)
            return
        end

        if (parameters.name) then
            setCreatureNickname(npc, parameters.name)
        end

        if (parameters.pet) then
            local pet = doCreateNpc("Pillar Model", position)
            if (not pet or not isCreature(pet)) then
                log(LOG_TYPES.ERROR, "Citizens::createNpc - Can't create Pet.", fileName, out, position, parameters)
                return
            end

            doCreatureChangeOutfit(pet, getMonsterInfo(parameters.pet).outfit)
            setCreatureNickname(pet, string.concat(parameters.firstname, "'s ",
                getMonsterInfo(parameters.pet).nickname))
            doCreatureFollowCreature(pet, npc)
        end
    end
end

function doStartCitizens()
    for i = 1, MALE_CITIZENS do
        local pet
        local voices = {}

        if (getRandom(1, 100) <= PET_CHANCE) then
            local petName = table.random(pokemonsNames)
            local tries = 0
            while (table.find(FORBIDDEN_POKEMON, petName)) do
                petName = table.random(pokemonsNames)

                if (tries == 100) then
                    petName = nil
                    break
                end
                tries = tries + 1
            end

            pet = petName

            -- FUTURE PROJECT voices[1] = {text = string.concat("Hey ", pet, " what about a rest now?"), interval = 1, margin = 5000}
        end


        local firstName = table.random(MALE_NAMES)
        createNpc(string.concat(FILE_PREFIX, i), generatePosition(), {
            firstname = firstName,
            name = string.concat(firstName, " ", table.random(LAST_NAMES)),
            floorchange = 0,
            walkinterval = getRandom(500, 4000),
            health = 100,
            look = {
                type = table.random(MALE_OUTFITS),
                head = getRandom(1, 255),
                body = getRandom(1, 255),
                legs = getRandom(1, 255),
                feet = getRandom(1, 255),
                addons = getRandom(0, 3)},
            interactions = {
                greet = generateGreet(),
                farewell = table.random(FAREWELLS)},
            voices = voices,
            pet = pet
        })
    end

    for i = 1, FEMALE_CITIZENS do
        local pet
        local voices = {}

        if (getRandom(1, 100) <= PET_CHANCE) then
            local petName = table.random(pokemonsNames)
            local tries = 0
            while (table.find(FORBIDDEN_POKEMON, petName)) do
                petName = table.random(pokemonsNames)

                if (tries == 100) then
                    petName = nil
                    break
                end
                tries = tries + 1
            end

            pet = petName

            -- FUTURE PROJECT voices[1] = {text = string.concat("Hey ", pet, " what about a rest now?"), interval = 1, margin = 5000}
        end


        local firstName = table.random(FEMALE_NAMES)
        createNpc(string.concat(FILE_PREFIX, (i + MALE_CITIZENS)), generatePosition(), {
            firstname = firstName,
            name = string.concat(firstName, " ", table.random(LAST_NAMES)),
            floorchange = 0,
            walkinterval = getRandom(500, 4000),
            health = 100,
            look = {
                type = table.random(FEMALE_OUTFITS),
                head = getRandom(1, 255),
                body = getRandom(1, 255),
                legs = getRandom(1, 255),
                feet = getRandom(1, 255),
                addons = getRandom(0, 3)},
            interactions = {
                greet = generateGreet(),
                farewell = table.random(FAREWELLS)},
            voices = voices,
            pet = pet
        })
    end
end
