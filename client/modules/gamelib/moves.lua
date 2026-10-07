local MOVES = {}
--MOVES[#MOVES + 1] = {name = "Protect", iconItemId = 11822}
--MOVES[#MOVES + 1] = {name = "Present", iconItemId = 16319}
--MOVES[#MOVES + 1] = {name = "Cross Chop", iconItemId = 11704}
--MOVES[#MOVES + 1] = {name = "Fire Fang", iconItemId = 12046}
--MOVES[#MOVES + 1] = {name = "Skull Bash", iconItemId = 12054}
--MOVES[#MOVES + 1] = {name = "Bounce", iconItemId = 16301}
--MOVES[#MOVES + 1] = {name = "String Shot", iconItemId = 11768}
--MOVES[#MOVES + 1] = {name = "Wake-Up Slap", iconItemId = 12082}
--MOVES[#MOVES + 1] = {name = "Quiver Dance", iconItemId = 12058}
--MOVES[#MOVES + 1] = {name = "Hypnosis", iconItemId = 11727}
--MOVES[#MOVES + 1] = {name = "Thrash", iconItemId = 12123}
--MOVES[#MOVES + 1] = {name = "Rain Dance", iconItemId = 12053}
--MOVES[#MOVES + 1] = {name = "Dizzy Punch", iconItemId = 11706}
--MOVES[#MOVES + 1] = {name = "Air Cutter", iconItemId = 12084}
--MOVES[#MOVES + 1] = {name = "Iron Head", iconItemId = 16314}
--MOVES[#MOVES + 1] = {name = "Bone Club", iconItemId = 11697}
--MOVES[#MOVES + 1] = {name = "Psywave", iconItemId = 15739}
--MOVES[#MOVES + 1] = {name = "Hex", iconItemId = 12113}
--MOVES[#MOVES + 1] = {name = "Rolling Kick", iconItemId = 12126}
--MOVES[#MOVES + 1] = {name = "Double-Edge", iconItemId = 11707}
--MOVES[#MOVES + 1] = {name = "Acid", iconItemId = 11693}
--MOVES[#MOVES + 1] = {name = "Crabhammer", iconItemId = 11703}
--MOVES[#MOVES + 1] = {name = "Metal Sound", iconItemId = 16315}
--MOVES[#MOVES + 1] = {name = "Toxic Spikes", iconItemId = 12066}
--MOVES[#MOVES + 1] = {name = "Dream Eater", iconItemId = 11710}
--MOVES[#MOVES + 1] = {name = "Crunch", iconItemId = 11705}
--MOVES[#MOVES + 1] = {name = "Shadow Ball", iconItemId = 12116}
--MOVES[#MOVES + 1] = {name = "Egg Bomb", iconItemId = 11713}
--MOVES[#MOVES + 1] = {name = "Substitute", iconItemId = 15742}
--MOVES[#MOVES + 1] = {name = "Payback", iconItemId = 12115}
--MOVES[#MOVES + 1] = {name = "Absorb", iconItemId = 11692}
--MOVES[#MOVES + 1] = {name = "Future Sight", iconItemId = 12093}
--MOVES[#MOVES + 1] = {name = "Cross Poison", iconItemId = 12086}
--MOVES[#MOVES + 1] = {name = "Ancient Power", iconItemId = 11694}
--MOVES[#MOVES + 1] = {name = "Leaf Storm", iconItemId = 12102}
--MOVES[#MOVES + 1] = {name = "Disable", iconItemId = 12089}
--MOVES[#MOVES + 1] = {name = "Hyper Fang", iconItemId = 11726}
--MOVES[#MOVES + 1] = {name = "Bonemerang", iconItemId = 11699}
--MOVES[#MOVES + 1] = {name = "Lick", iconItemId = 11734}
--MOVES[#MOVES + 1] = {name = "Vital Throw", iconItemId = 12098}
--MOVES[#MOVES + 1] = {name = "Swift", iconItemId = 11770}
--MOVES[#MOVES + 1] = {name = "Sonic Boom", iconItemId = 11764}
--MOVES[#MOVES + 1] = {name = "Rock Tomb", iconItemId = 16322}
--MOVES[#MOVES + 1] = {name = "Supersonic", iconItemId = 11769}
--MOVES[#MOVES + 1] = {name = "Selfdestruct", iconItemId = 11802}
--MOVES[#MOVES + 1] = {name = "Rapid Spin", iconItemId = 13113}
--MOVES[#MOVES + 1] = {name = "Stored Power", iconItemId = 16330}
--MOVES[#MOVES + 1] = {name = "Meditate", iconItemId = 12119}
--MOVES[#MOVES + 1] = {name = "Rest", iconItemId = 11825}
--MOVES[#MOVES + 1] = {name = "Bullet Punch", iconItemId = 12127}
--MOVES[#MOVES + 1] = {name = "Charge", iconItemId = 16303}
--MOVES[#MOVES + 1] = {name = "Confuse Ray", iconItemId = 11781}
--MOVES[#MOVES + 1] = {name = "Blizzard", iconItemId = 11779}
--MOVES[#MOVES + 1] = {name = "Mist Ball", iconItemId = 11748}
--MOVES[#MOVES + 1] = {name = "Hyper Voice", iconItemId = 11791}
--MOVES[#MOVES + 1] = {name = "Mega Kick", iconItemId = 11739}
--MOVES[#MOVES + 1] = {name = "Mirror Move", iconItemId = 13111}
--MOVES[#MOVES + 1] = {name = "Poison Sting", iconItemId = 11746}
--MOVES[#MOVES + 1] = {name = "Acrobatics", iconItemId = 16299}
--MOVES[#MOVES + 1] = {name = "Poison Jab", iconItemId = 12063}
--MOVES[#MOVES + 1] = {name = "Ice Beam", iconItemId = 11792}
--MOVES[#MOVES + 1] = {name = "Amnesia", iconItemId = 12090}
--MOVES[#MOVES + 1] = {name = "Explosion", iconItemId = 11784}
--MOVES[#MOVES + 1] = {name = "Drill Peck", iconItemId = 11711}
--MOVES[#MOVES + 1] = {name = "Double Hit", iconItemId = 12130}
--MOVES[#MOVES + 1] = {name = "Sludge Bomb", iconItemId = 11760}
--MOVES[#MOVES + 1] = {name = "Psybeam", iconItemId = 11800}
--MOVES[#MOVES + 1] = {name = "Sleep Powder", iconItemId = 11805}
--MOVES[#MOVES + 1] = {name = "Electro Ball", iconItemId = 12077}
--MOVES[#MOVES + 1] = {name = "Sand Tomb", iconItemId = 12078}
--MOVES[#MOVES + 1] = {name = "Smoke Screen", iconItemId = 12049}
--MOVES[#MOVES + 1] = {name = "Power Whip", iconItemId = 12128}
--MOVES[#MOVES + 1] = {name = "Razor Leaf", iconItemId = 11750}
--MOVES[#MOVES + 1] = {name = "Mega Punch", iconItemId = 11740}
--MOVES[#MOVES + 1] = {name = "Confusion", iconItemId = 11782}
--MOVES[#MOVES + 1] = {name = "Flame Burst", iconItemId = 12047}
--MOVES[#MOVES + 1] = {name = "Venoshock", iconItemId = 12765}
--MOVES[#MOVES + 1] = {name = "Acid Armor", iconItemId = 12137}
--MOVES[#MOVES + 1] = {name = "Horn Drill", iconItemId = 11725}
--MOVES[#MOVES + 1] = {name = "Flare Blitz", iconItemId = 12092}
--MOVES[#MOVES + 1] = {name = "Vine Whip", iconItemId = 11811}
--MOVES[#MOVES + 1] = {name = "Seismic Toss", iconItemId = 11756}
--MOVES[#MOVES + 1] = {name = "Solar Beam", iconItemId = 11806}
--MOVES[#MOVES + 1] = {name = "Flame Wheel", iconItemId = 11786}
--MOVES[#MOVES + 1] = {name = "Smog", iconItemId = 11762}
--MOVES[#MOVES + 1] = {name = "Brick Break", iconItemId = 11700}
--MOVES[#MOVES + 1] = {name = "Coil", iconItemId = 12074}
--MOVES[#MOVES + 1] = {name = "Bide", iconItemId = 15737}
--MOVES[#MOVES + 1] = {name = "Dragon Dance", iconItemId = 12144}
--MOVES[#MOVES + 1] = {name = "Yawn", iconItemId = 16336}
--MOVES[#MOVES + 1] = {name = "Eruption", iconItemId = 16308}
--MOVES[#MOVES + 1] = {name = "Double Kick", iconItemId = 11708}
--MOVES[#MOVES + 1] = {name = "Fissure", iconItemId = 11717}
--MOVES[#MOVES + 1] = {name = "Spark", iconItemId = 16326}
--MOVES[#MOVES + 1] = {name = "Spore", iconItemId = 11767}
--MOVES[#MOVES + 1] = {name = "Power Gem", iconItemId = 12088}
--MOVES[#MOVES + 1] = {name = "Grass Whistle", iconItemId = 16311}
--MOVES[#MOVES + 1] = {name = "Night Slash", iconItemId = 12087}
--MOVES[#MOVES + 1] = {name = "Peck", iconItemId = 12132}
--MOVES[#MOVES + 1] = {name = "Faint Attack", iconItemId = 16672}
--MOVES[#MOVES + 1] = {name = "Outrage", iconItemId = 12131}
--MOVES[#MOVES + 1] = {name = "Rollout", iconItemId = 12032}
--MOVES[#MOVES + 1] = {name = "Will-O-Wisp", iconItemId = 11777}
--MOVES[#MOVES + 1] = {name = "Bite", iconItemId = 11695}
--MOVES[#MOVES + 1] = {name = "Silver Wind", iconItemId = 11803}
--MOVES[#MOVES + 1] = {name = "Bug Bite", iconItemId = 11702}
--MOVES[#MOVES + 1] = {name = "Horn Attack", iconItemId = 11724}
--MOVES[#MOVES + 1] = {name = "Moonlight", iconItemId = 11821}
--MOVES[#MOVES + 1] = {name = "Thunder Wave", iconItemId = 11809}
--MOVES[#MOVES + 1] = {name = "Stealth Rock", iconItemId = 12106}
--MOVES[#MOVES + 1] = {name = "Fury Swipes", iconItemId = 11719}
--MOVES[#MOVES + 1] = {name = "Powder Snow", iconItemId = 11799}
--MOVES[#MOVES + 1] = {name = "Frenzy Plant", iconItemId = 16673}
--MOVES[#MOVES + 1] = {name = "Submission", iconItemId = 12097}
--MOVES[#MOVES + 1] = {name = "Rock Slide", iconItemId = 12764}
--MOVES[#MOVES + 1] = {name = "Curse", iconItemId = 12111}
--MOVES[#MOVES + 1] = {name = "Hammer Arm", iconItemId = 16312}
--MOVES[#MOVES + 1] = {name = "Superpower", iconItemId = 12081}
--MOVES[#MOVES + 1] = {name = "Iron Tail", iconItemId = 11729}
--MOVES[#MOVES + 1] = {name = "Tackle", iconItemId = 12026}
--MOVES[#MOVES + 1] = {name = "Signal Beam", iconItemId = 12140}
--MOVES[#MOVES + 1] = {name = "Flamethrower", iconItemId = 11787}
--MOVES[#MOVES + 1] = {name = "Inferno", iconItemId = 12050}
--MOVES[#MOVES + 1] = {name = "Tri Attack", iconItemId = 11776}
--MOVES[#MOVES + 1] = {name = "Zap Cannon", iconItemId = 12109}
--MOVES[#MOVES + 1] = {name = "Mimic", iconItemId = 11741}
--MOVES[#MOVES + 1] = {name = "Sludge", iconItemId = 11761}
--MOVES[#MOVES + 1] = {name = "Water Gun", iconItemId = 11813}
--MOVES[#MOVES + 1] = {name = "Megahorn", iconItemId = 11738}
--MOVES[#MOVES + 1] = {name = "Scary Face", iconItemId = 11754}
--MOVES[#MOVES + 1] = {name = "Guillotine", iconItemId = 11722}
--MOVES[#MOVES + 1] = {name = "Bubble", iconItemId = 11701}
--MOVES[#MOVES + 1] = {name = "Psychic", iconItemId = 11801}
--MOVES[#MOVES + 1] = {name = "Hyper Beam", iconItemId = 11790}
--MOVES[#MOVES + 1] = {name = "Earthquake", iconItemId = 11783}
--MOVES[#MOVES + 1] = {name = "Feather Dance", iconItemId = 12069}
--MOVES[#MOVES + 1] = {name = "Mega Drain", iconItemId = 11737}
--MOVES[#MOVES + 1] = {name = "Flame Charge", iconItemId = 16310}
--MOVES[#MOVES + 1] = {name = "Captivate", iconItemId = 12059}
--MOVES[#MOVES + 1] = {name = "Jump Kick", iconItemId = 11730}
--MOVES[#MOVES + 1] = {name = "Lava Plume", iconItemId = 12763}
--MOVES[#MOVES + 1] = {name = "Healing Wish", iconItemId = 12083}
--MOVES[#MOVES + 1] = {name = "Double Slap", iconItemId = 11709}
--MOVES[#MOVES + 1] = {name = "Endeavor", iconItemId = 12061}
--MOVES[#MOVES + 1] = {name = "Ember", iconItemId = 11714}
--MOVES[#MOVES + 1] = {name = "Gunk Shot", iconItemId = 12075}
--MOVES[#MOVES + 1] = {name = "Reversal", iconItemId = 11751}
--MOVES[#MOVES + 1] = {name = "Softboiled", iconItemId = 11826}
--MOVES[#MOVES + 1] = {name = "Agility", iconItemId = 11817}
--MOVES[#MOVES + 1] = {name = "Drill Run", iconItemId = 12071}
--MOVES[#MOVES + 1] = {name = "Icy Wind", iconItemId = 11793}
--MOVES[#MOVES + 1] = {name = "Stomp", iconItemId = 11807}
--MOVES[#MOVES + 1] = {name = "Leech Seed", iconItemId = 11733}
--MOVES[#MOVES + 1] = {name = "Worry Seed", iconItemId = 12044}
--MOVES[#MOVES + 1] = {name = "Spike Cannon", iconItemId = 11765}
--MOVES[#MOVES + 1] = {name = "Swords Dance", iconItemId = 12135}
--MOVES[#MOVES + 1] = {name = "Bug Buzz", iconItemId = 12057}
--MOVES[#MOVES + 1] = {name = "Earth Power", iconItemId = 12080}
--MOVES[#MOVES + 1] = {name = "Charm", iconItemId = 16304}
--MOVES[#MOVES + 1] = {name = "Hurricane", iconItemId = 11814}
--MOVES[#MOVES + 1] = {name = "Milk Drink", iconItemId = 16316}
--MOVES[#MOVES + 1] = {name = "Fire Spin", iconItemId = 11716}
--MOVES[#MOVES + 1] = {name = "Dynamic Punch", iconItemId = 11712}
--MOVES[#MOVES + 1] = {name = "Dark Pulse", iconItemId = 12112}
--MOVES[#MOVES + 1] = {name = "Shadow Punch", iconItemId = 11757}
--MOVES[#MOVES + 1] = {name = "Thunder Shock", iconItemId = 11773}
--MOVES[#MOVES + 1] = {name = "Muddy Water", iconItemId = 12138}
--MOVES[#MOVES + 1] = {name = "Counter", iconItemId = 15738}
--MOVES[#MOVES + 1] = {name = "Pound", iconItemId = 11747}
--MOVES[#MOVES + 1] = {name = "Metal Claw", iconItemId = 12048}
--MOVES[#MOVES + 1] = {name = "Meowth Super Rocket", iconItemId = 0}
--MOVES[#MOVES + 1] = {name = "Rocket Missile", iconItemId = 0}
--MOVES[#MOVES + 1] = {name = "Wish", iconItemId = 16334}
--MOVES[#MOVES + 1] = {name = "Nasty Plot", iconItemId = 16317}
--MOVES[#MOVES + 1] = {name = "Ominous Wind", iconItemId = 16318}
--MOVES[#MOVES + 1] = {name = "Clear Smog", iconItemId = 12129}
--MOVES[#MOVES + 1] = {name = "Haze", iconItemId = 16313}
--MOVES[#MOVES + 1] = {name = "Bone Rush", iconItemId = 11698}
--MOVES[#MOVES + 1] = {name = "Psycho Shift", iconItemId = 16321}
--MOVES[#MOVES + 1] = {name = "Cotton Guard", iconItemId = 16305}
--MOVES[#MOVES + 1] = {name = "Rage Powder", iconItemId = 12056}
--MOVES[#MOVES + 1] = {name = "Mud Shot", iconItemId = 11742}
--MOVES[#MOVES + 1] = {name = "Barrier", iconItemId = 12133}
--MOVES[#MOVES + 1] = {name = "Ice Fang", iconItemId = 12142}
--MOVES[#MOVES + 1] = {name = "Magic Coat", iconItemId = 12139}
--MOVES[#MOVES + 1] = {name = "Double Team", iconItemId = 13108}
--MOVES[#MOVES + 1] = {name = "Refresh", iconItemId = 11824}
--MOVES[#MOVES + 1] = {name = "Mirror Coat", iconItemId = 12122}
--MOVES[#MOVES + 1] = {name = "Hydro Cannon", iconItemId = 11812}
--MOVES[#MOVES + 1] = {name = "Poison Fang", iconItemId = 11745}
--MOVES[#MOVES + 1] = {name = "Snore", iconItemId = 11763}
--MOVES[#MOVES + 1] = {name = "Reflect", iconItemId = 12095}
--MOVES[#MOVES + 1] = {name = "Thunder Punch", iconItemId = 11772}
--MOVES[#MOVES + 1] = {name = "Focus Energy", iconItemId = 12062}
--MOVES[#MOVES + 1] = {name = "Synthesis", iconItemId = 12043}
--MOVES[#MOVES + 1] = {name = "Safeguard", iconItemId = 12124}
--MOVES[#MOVES + 1] = {name = "Rage", iconItemId = 12065}
--MOVES[#MOVES + 1] = {name = "Harden", iconItemId = 11820}
--MOVES[#MOVES + 1] = {name = "Recover", iconItemId = 11823}
--MOVES[#MOVES + 1] = {name = "Dragon Tail", iconItemId = 12762}
--MOVES[#MOVES + 1] = {name = "Defense Curl", iconItemId = 11819}
--MOVES[#MOVES + 1] = {name = "Meteor Mash", iconItemId = 11795}
--MOVES[#MOVES + 1] = {name = "Triple Kick", iconItemId = 16333}
--MOVES[#MOVES + 1] = {name = "Gyro Ball", iconItemId = 16675}
--MOVES[#MOVES + 1] = {name = "Calm Mind", iconItemId = 11818}
--MOVES[#MOVES + 1] = {name = "Aromatherapy", iconItemId = 12085}
--MOVES[#MOVES + 1] = {name = "Quick Attack", iconItemId = 11749}
--MOVES[#MOVES + 1] = {name = "Twineedle", iconItemId = 12067}
--MOVES[#MOVES + 1] = {name = "Steel Wing", iconItemId = 16328}
--MOVES[#MOVES + 1] = {name = "Extrasensory", iconItemId = 16309}
--MOVES[#MOVES + 1] = {name = "Body Slam", iconItemId = 11696}
--MOVES[#MOVES + 1] = {name = "Focus Punch", iconItemId = 13109}
--MOVES[#MOVES + 1] = {name = "Giga Impact", iconItemId = 12141}
--MOVES[#MOVES + 1] = {name = "Magnitude", iconItemId = 11794}
--MOVES[#MOVES + 1] = {name = "Karate Chop", iconItemId = 11731}
--MOVES[#MOVES + 1] = {name = "Mud Bomb", iconItemId = 12073}
--MOVES[#MOVES + 1] = {name = "Pin Missile", iconItemId = 11744}
--MOVES[#MOVES + 1] = {name = "Fury Cutter", iconItemId = 16674}
--MOVES[#MOVES + 1] = {name = "X-Scissor", iconItemId = 12136}
--MOVES[#MOVES + 1] = {name = "Charge Beam", iconItemId = 12121}
--MOVES[#MOVES + 1] = {name = "Brine", iconItemId = 12120}
--MOVES[#MOVES + 1] = {name = "Constrict", iconItemId = 12103}
--MOVES[#MOVES + 1] = {name = "Scratch", iconItemId = 11755}
--MOVES[#MOVES + 1] = {name = "Psycho Cut", iconItemId = 12094}
--MOVES[#MOVES + 1] = {name = "Leaf Tornado", iconItemId = 12100}
--MOVES[#MOVES + 1] = {name = "Giga Drain", iconItemId = 11720}
--MOVES[#MOVES + 1] = {name = "Sludge Wave", iconItemId = 12104}
--MOVES[#MOVES + 1] = {name = "Comet Punch", iconItemId = 13107}
--MOVES[#MOVES + 1] = {name = "Discharge", iconItemId = 12076}
--MOVES[#MOVES + 1] = {name = "Zen Headbutt", iconItemId = 13115}
--MOVES[#MOVES + 1] = {name = "Mirror Shot", iconItemId = 12108}
--MOVES[#MOVES + 1] = {name = "Rock Throw", iconItemId = 11753}
--MOVES[#MOVES + 1] = {name = "Acid Spray", iconItemId = 12072}
--MOVES[#MOVES + 1] = {name = "Wrap", iconItemId = 13114}
--MOVES[#MOVES + 1] = {name = "Twister", iconItemId = 12068}
--MOVES[#MOVES + 1] = {name = "Tailwind", iconItemId = 12060}
--MOVES[#MOVES + 1] = {name = "Flash Cannon", iconItemId = 12052}
--MOVES[#MOVES + 1] = {name = "Petal Dance", iconItemId = 12045}
--MOVES[#MOVES + 1] = {name = "Wring Out", iconItemId = 12105}
--MOVES[#MOVES + 1] = {name = "Heal Pulse", iconItemId = 12035}
--MOVES[#MOVES + 1] = {name = "Air Slash", iconItemId = 12033}
--MOVES[#MOVES + 1] = {name = "Water Pulse", iconItemId = 12055}
--MOVES[#MOVES + 1] = {name = "Crush Claw", iconItemId = 12079}
--MOVES[#MOVES + 1] = {name = "Lovely Kiss", iconItemId = 11735}
--MOVES[#MOVES + 1] = {name = "Fire Blast", iconItemId = 11785}
--MOVES[#MOVES + 1] = {name = "Thunder", iconItemId = 11810}
--MOVES[#MOVES + 1] = {name = "Stun Spore", iconItemId = 11808}
--MOVES[#MOVES + 1] = {name = "Leech Life", iconItemId = 11732}
--MOVES[#MOVES + 1] = {name = "Sing", iconItemId = 11804}
--MOVES[#MOVES + 1] = {name = "Poison Powder", iconItemId = 11798}
--MOVES[#MOVES + 1] = {name = "Poison Gas", iconItemId = 11797}
--MOVES[#MOVES + 1] = {name = "Headbutt", iconItemId = 11723}
--MOVES[#MOVES + 1] = {name = "Sweet Kiss", iconItemId = 16331}
--MOVES[#MOVES + 1] = {name = "Metronome", iconItemId = 11796}
--MOVES[#MOVES + 1] = {name = "Hydro Pump", iconItemId = 11789}
--MOVES[#MOVES + 1] = {name = "Fire Punch", iconItemId = 11715}
--MOVES[#MOVES + 1] = {name = "Wing Attack", iconItemId = 11815}
--MOVES[#MOVES + 1] = {name = "Ice Punch", iconItemId = 11728}
--MOVES[#MOVES + 1] = {name = "Thunder Fang", iconItemId = 12143}
--MOVES[#MOVES + 1] = {name = "Bubblebeam", iconItemId = 11780}
--MOVES[#MOVES + 1] = {name = "Aurora Beam", iconItemId = 11778}
--MOVES[#MOVES + 1] = {name = "Punishment", iconItemId = 16676}
--MOVES[#MOVES + 1] = {name = "Drain Punch", iconItemId = 16671}
--MOVES[#MOVES + 1] = {name = "Screech", iconItemId = 16677}
--MOVES[#MOVES + 1] = {name = "Wood Hammer", iconItemId = 16335}
--MOVES[#MOVES + 1] = {name = "Tickle", iconItemId = 16332}
--MOVES[#MOVES + 1] = {name = "Stone Edge", iconItemId = 16329}
--MOVES[#MOVES + 1] = {name = "Spider Web", iconItemId = 16327}
--MOVES[#MOVES + 1] = {name = "Bullet Seed", iconItemId = 16302}
--MOVES[#MOVES + 1] = {name = "Sketch", iconItemId = 16325}
--MOVES[#MOVES + 1] = {name = "Shock Wave", iconItemId = 16324}
--MOVES[#MOVES + 1] = {name = "Aqua Ring", iconItemId = 16300}
--MOVES[#MOVES + 1] = {name = "Magical Leaf", iconItemId = 12134}
--MOVES[#MOVES + 1] = {name = "Electroweb", iconItemId = 16307}
--MOVES[#MOVES + 1] = {name = "Aerial Ace", iconItemId = 12070}
--MOVES[#MOVES + 1] = {name = "Dragon Pulse", iconItemId = 16306}
--MOVES[#MOVES + 1] = {name = "Night Shade", iconItemId = 11743}
--MOVES[#MOVES + 1] = {name = "Nightmare", iconItemId = 12114}
--MOVES[#MOVES + 1] = {name = "Aqua Tail", iconItemId = 12051}
--MOVES[#MOVES + 1] = {name = "Dragon Rage", iconItemId = 15797}
--MOVES[#MOVES + 1] = {name = "Slash", iconItemId = 11759}
--MOVES[#MOVES + 1] = {name = "Toxic", iconItemId = 15743}
--MOVES[#MOVES + 1] = {name = "Fury Attack", iconItemId = 11718}
--MOVES[#MOVES + 1] = {name = "Sucker Punch", iconItemId = 12118}
--MOVES[#MOVES + 1] = {name = "Mud-Slap", iconItemId = 13112}
--MOVES[#MOVES + 1] = {name = "Glare", iconItemId = 11721}
--MOVES[#MOVES + 1] = {name = "Hi Jump Kick", iconItemId = 12125}
--MOVES[#MOVES + 1] = {name = "Splash", iconItemId = 11766}
--MOVES[#MOVES + 1] = {name = "Spite", iconItemId = 12117}
--MOVES[#MOVES + 1] = {name = "Razor Shell", iconItemId = 12110}
--MOVES[#MOVES + 1] = {name = "Thunderbolt", iconItemId = 11774}
--MOVES[#MOVES + 1] = {name = "Leaf Blade", iconItemId = 12101}
--MOVES[#MOVES + 1] = {name = "Revenge", iconItemId = 12099}
--MOVES[#MOVES + 1] = {name = "Ally Switch", iconItemId = 12096}
--MOVES[#MOVES + 1] = {name = "Take Down", iconItemId = 11771}
--MOVES[#MOVES + 1] = {name = "Low Kick", iconItemId = 11736}
--MOVES[#MOVES + 1] = {name = "Close Combat", iconItemId = 12091}
--MOVES[#MOVES + 1] = {name = "Sand-Attack", iconItemId = 12034}
--MOVES[#MOVES + 1] = {name = "Pursuit", iconItemId = 12064}
--MOVES[#MOVES + 1] = {name = "Transform", iconItemId = 11775}
--MOVES[#MOVES + 1] = {name = "Magnet Bomb", iconItemId = 12107}
--MOVES[#MOVES + 1] = {name = "Sky Attack", iconItemId = 15741}
--MOVES[#MOVES + 1] = {name = "Slam", iconItemId = 11758}
--MOVES[#MOVES + 1] = {name = "Rock Blast", iconItemId = 11752}
--MOVES[#MOVES + 1] = {name = "Shadow Sneak", iconItemId = 16323}
--MOVES[#MOVES + 1] = {name = "Ice Shard", iconItemId = 13110}
--MOVES[#MOVES + 1] = {name = "Razor Wind", iconItemId = 15740}
--MOVES[#MOVES + 1] = {name = "Gust", iconItemId = 11788}
--MOVES[#MOVES + 1] = {name = "Conversion2", iconItemId = 17581}
--MOVES[#MOVES + 1] = {name = "Extreme Speed", iconItemId = 17582}
--MOVES[#MOVES + 1] = {name = "Roost", iconItemId = 17583}
--MOVES[#MOVES + 1] = {name = "Spit Up", iconItemId = 17584}
--MOVES[#MOVES + 1] = {name = "Stockpile", iconItemId = 17585}
--MOVES[#MOVES + 1] = {name = "Swallow", iconItemId = 17586}
MOVES[#MOVES + 1] = {name = "Protect", iconItemId = 11822}
MOVES[#MOVES + 1] = {name = "Present", iconItemId = 16319}
MOVES[#MOVES + 1] = {name = "Cross Chop", iconItemId = 11704}
MOVES[#MOVES + 1] = {name = "Fire Fang", iconItemId = 12046}
MOVES[#MOVES + 1] = {name = "Skull Bash", iconItemId = 12054}
MOVES[#MOVES + 1] = {name = "Tickle", iconItemId = 16332}
MOVES[#MOVES + 1] = {name = "String Shot", iconItemId = 11768}
MOVES[#MOVES + 1] = {name = "Leaf Blade", iconItemId = 12101}
MOVES[#MOVES + 1] = {name = "Quiver Dance", iconItemId = 12058}
MOVES[#MOVES + 1] = {name = "Vice Grip", iconItemId = 27607}
MOVES[#MOVES + 1] = {name = "Weather Ball", iconItemId = 27606}
MOVES[#MOVES + 1] = {name = "Hypnosis", iconItemId = 11727}
MOVES[#MOVES + 1] = {name = "Aeroblast", iconItemId = 26895}
MOVES[#MOVES + 1] = {name = "Thrash", iconItemId = 12123}
MOVES[#MOVES + 1] = {name = "Rain Dance", iconItemId = 12053}
MOVES[#MOVES + 1] = {name = "Transform", iconItemId = 11775}
MOVES[#MOVES + 1] = {name = "Air Cutter", iconItemId = 12084}
MOVES[#MOVES + 1] = {name = "Iron Head", iconItemId = 16314}
MOVES[#MOVES + 1] = {name = "Bone Club", iconItemId = 11697}
MOVES[#MOVES + 1] = {name = "Psywave", iconItemId = 15739}
MOVES[#MOVES + 1] = {name = "Moonblast", iconItemId = 26938}
MOVES[#MOVES + 1] = {name = "Sandstorm", iconItemId = 26970}
MOVES[#MOVES + 1] = {name = "Miracle Eye", iconItemId = 26937}
MOVES[#MOVES + 1] = {name = "Hex", iconItemId = 12113}
MOVES[#MOVES + 1] = {name = "Heavy Slam", iconItemId = 26926}
MOVES[#MOVES + 1] = {name = "Aqua Jet", iconItemId = 26896}
MOVES[#MOVES + 1] = {name = "Camouflage", iconItemId = 27610}
MOVES[#MOVES + 1] = {name = "Waterfall", iconItemId = 27622}
MOVES[#MOVES + 1] = {name = "Acid", iconItemId = 11693}
MOVES[#MOVES + 1] = {name = "Crabhammer", iconItemId = 11703}
MOVES[#MOVES + 1] = {name = "Metal Sound", iconItemId = 16315}
MOVES[#MOVES + 1] = {name = "Toxic Spikes", iconItemId = 12066}
MOVES[#MOVES + 1] = {name = "Venom Drench", iconItemId = 27666}
MOVES[#MOVES + 1] = {name = "Dream Eater", iconItemId = 11710}
MOVES[#MOVES + 1] = {name = "Crunch", iconItemId = 11705}
MOVES[#MOVES + 1] = {name = "Shadow Ball", iconItemId = 12116}
MOVES[#MOVES + 1] = {name = "Egg Bomb", iconItemId = 11713}
MOVES[#MOVES + 1] = {name = "Substitute", iconItemId = 15742}
MOVES[#MOVES + 1] = {name = "Simple Beam", iconItemId = 27663}
MOVES[#MOVES + 1] = {name = "Heal Bell", iconItemId = 26923}
MOVES[#MOVES + 1] = {name = "Payback", iconItemId = 12115}
MOVES[#MOVES + 1] = {name = "Avalanche", iconItemId = 23372}
MOVES[#MOVES + 1] = {name = "Octazooka", iconItemId = 26940}
MOVES[#MOVES + 1] = {name = "Future Sight", iconItemId = 12093}
MOVES[#MOVES + 1] = {name = "Fell Stinger", iconItemId = 27651}
MOVES[#MOVES + 1] = {name = "Cross Poison", iconItemId = 12086}
MOVES[#MOVES + 1] = {name = "Dragon Breath", iconItemId = 26909}
MOVES[#MOVES + 1] = {name = "Ancient Power", iconItemId = 11694}
MOVES[#MOVES + 1] = {name = "Leaf Storm", iconItemId = 12102}
MOVES[#MOVES + 1] = {name = "Disable", iconItemId = 12089}
MOVES[#MOVES + 1] = {name = "Hyper Fang", iconItemId = 11726}
MOVES[#MOVES + 1] = {name = "Bonemerang", iconItemId = 11699}
MOVES[#MOVES + 1] = {name = "Lick", iconItemId = 11734}
MOVES[#MOVES + 1] = {name = "Vital Throw", iconItemId = 12098}
MOVES[#MOVES + 1] = {name = "Psyshock", iconItemId = 26968}
MOVES[#MOVES + 1] = {name = "Blaze Kick", iconItemId = 26901}
MOVES[#MOVES + 1] = {name = "Swift", iconItemId = 11770}
MOVES[#MOVES + 1] = {name = "Sonic Boom", iconItemId = 11764}
MOVES[#MOVES + 1] = {name = "Flower Shield", iconItemId = 26915}
MOVES[#MOVES + 1] = {name = "Rock Tomb", iconItemId = 16322}
MOVES[#MOVES + 1] = {name = "Supersonic", iconItemId = 11769}
MOVES[#MOVES + 1] = {name = "Psychic Fangs", iconItemId = 27667}
MOVES[#MOVES + 1] = {name = "Ingrain", iconItemId = 26930}
MOVES[#MOVES + 1] = {name = "Freeze-Dry", iconItemId = 26919}
MOVES[#MOVES + 1] = {name = "Covet", iconItemId = 26905}
MOVES[#MOVES + 1] = {name = "Rapid Spin", iconItemId = 13113}
MOVES[#MOVES + 1] = {name = "Stored Power", iconItemId = 16330}
MOVES[#MOVES + 1] = {name = "Energy Ball", iconItemId = 23371}
MOVES[#MOVES + 1] = {name = "Eerie Impulse", iconItemId = 27652}
MOVES[#MOVES + 1] = {name = "Foresight", iconItemId = 26917}
MOVES[#MOVES + 1] = {name = "Rest", iconItemId = 11825}
MOVES[#MOVES + 1] = {name = "Gust", iconItemId = 11788}
MOVES[#MOVES + 1] = {name = "Bullet Punch", iconItemId = 12127}
MOVES[#MOVES + 1] = {name = "Charge", iconItemId = 16303}
MOVES[#MOVES + 1] = {name = "Luster Purge", iconItemId = 27615}
MOVES[#MOVES + 1] = {name = "Confuse Ray", iconItemId = 11781}
MOVES[#MOVES + 1] = {name = "Blizzard", iconItemId = 11779}
MOVES[#MOVES + 1] = {name = "Mist Ball", iconItemId = 11748}
MOVES[#MOVES + 1] = {name = "Eruption", iconItemId = 16308}
MOVES[#MOVES + 1] = {name = "Echoed Voice", iconItemId = 27609}
MOVES[#MOVES + 1] = {name = "Hyper Voice", iconItemId = 11791}
MOVES[#MOVES + 1] = {name = "Ally Switch", iconItemId = 12096}
MOVES[#MOVES + 1] = {name = "Fire Blast", iconItemId = 11785}
MOVES[#MOVES + 1] = {name = "Hidden Power", iconItemId = 26965}
MOVES[#MOVES + 1] = {name = "Toxic", iconItemId = 15743}
MOVES[#MOVES + 1] = {name = "Flail", iconItemId = 27605}
MOVES[#MOVES + 1] = {name = "Acrobatics", iconItemId = 16299}
MOVES[#MOVES + 1] = {name = "Poison Gas", iconItemId = 11797}
MOVES[#MOVES + 1] = {name = "Vine Whip", iconItemId = 11811}
MOVES[#MOVES + 1] = {name = "Chip Away", iconItemId = 26903}
MOVES[#MOVES + 1] = {name = "Ice Beam", iconItemId = 11792}
MOVES[#MOVES + 1] = {name = "Magnet Bomb", iconItemId = 12107}
MOVES[#MOVES + 1] = {name = "Grassy Terrain", iconItemId = 27658}
MOVES[#MOVES + 1] = {name = "Amnesia", iconItemId = 12090}
MOVES[#MOVES + 1] = {name = "Acid Spray", iconItemId = 12072}
MOVES[#MOVES + 1] = {name = "Giga Drain", iconItemId = 11720}
MOVES[#MOVES + 1] = {name = "Drill Peck", iconItemId = 11711}
MOVES[#MOVES + 1] = {name = "Double Hit", iconItemId = 12130}
MOVES[#MOVES + 1] = {name = "Sludge Bomb", iconItemId = 11760}
MOVES[#MOVES + 1] = {name = "Brine", iconItemId = 12120}
MOVES[#MOVES + 1] = {name = "Mud Bomb", iconItemId = 12073}
MOVES[#MOVES + 1] = {name = "Fake Out", iconItemId = 27602}
MOVES[#MOVES + 1] = {name = "Detect", iconItemId = 27588}
MOVES[#MOVES + 1] = {name = "Electro Ball", iconItemId = 12077}
MOVES[#MOVES + 1] = {name = "Electroweb", iconItemId = 16307}
MOVES[#MOVES + 1] = {name = "Encore", iconItemId = 26912}
MOVES[#MOVES + 1] = {name = "Sand Tomb", iconItemId = 12078}
MOVES[#MOVES + 1] = {name = "Heal Pulse", iconItemId = 12035}
MOVES[#MOVES + 1] = {name = "Smoke Screen", iconItemId = 12049}
MOVES[#MOVES + 1] = {name = "Hone Claws", iconItemId = 27579}
MOVES[#MOVES + 1] = {name = "Power Whip", iconItemId = 12128}
MOVES[#MOVES + 1] = {name = "Razor Leaf", iconItemId = 11750}
MOVES[#MOVES + 1] = {name = "Explosion", iconItemId = 11784}
MOVES[#MOVES + 1] = {name = "Mega Punch", iconItemId = 11740}
MOVES[#MOVES + 1] = {name = "Boomburst", iconItemId = 27608}
MOVES[#MOVES + 1] = {name = "Confusion", iconItemId = 11782}
MOVES[#MOVES + 1] = {name = "Synchronoise", iconItemId = 26956}
MOVES[#MOVES + 1] = {name = "Growl", iconItemId = 26922}
MOVES[#MOVES + 1] = {name = "Venoshock", iconItemId = 12765}
MOVES[#MOVES + 1] = {name = "Draining Kiss", iconItemId = 26911}
MOVES[#MOVES + 1] = {name = "Endure", iconItemId = 26963}
MOVES[#MOVES + 1] = {name = "Spiky Shield", iconItemId = 27593}
MOVES[#MOVES + 1] = {name = "Dark Pulse", iconItemId = 12112}
MOVES[#MOVES + 1] = {name = "Acid Armor", iconItemId = 12137}
MOVES[#MOVES + 1] = {name = "Horn Drill", iconItemId = 11725}
MOVES[#MOVES + 1] = {name = "Flare Blitz", iconItemId = 12092}
MOVES[#MOVES + 1] = {name = "Aurora Beam", iconItemId = 11778}
MOVES[#MOVES + 1] = {name = "Selfdestruct", iconItemId = 11802}
MOVES[#MOVES + 1] = {name = "Wood Hammer", iconItemId = 16335}
MOVES[#MOVES + 1] = {name = "Scald", iconItemId = 26947}
MOVES[#MOVES + 1] = {name = "Belch", iconItemId = 26900}
MOVES[#MOVES + 1] = {name = "Sleep Powder", iconItemId = 11805}
MOVES[#MOVES + 1] = {name = "Sunny Day", iconItemId = 26954}
MOVES[#MOVES + 1] = {name = "Seismic Toss", iconItemId = 11756}
MOVES[#MOVES + 1] = {name = "Solar Beam", iconItemId = 11806}
MOVES[#MOVES + 1] = {name = "Flame Wheel", iconItemId = 11786}
MOVES[#MOVES + 1] = {name = "Heat Wave", iconItemId = 26925}
MOVES[#MOVES + 1] = {name = "Smog", iconItemId = 11762}
MOVES[#MOVES + 1] = {name = "Astonish", iconItemId = 26961}
MOVES[#MOVES + 1] = {name = "Brick Break", iconItemId = 11700}
MOVES[#MOVES + 1] = {name = "Coil", iconItemId = 12074}
MOVES[#MOVES + 1] = {name = "Bide", iconItemId = 15737}
MOVES[#MOVES + 1] = {name = "Dragon Dance", iconItemId = 12144}
MOVES[#MOVES + 1] = {name = "Yawn", iconItemId = 16336}
MOVES[#MOVES + 1] = {name = "Metal Burst", iconItemId = 27617}
MOVES[#MOVES + 1] = {name = "Lunge", iconItemId = 27650}
MOVES[#MOVES + 1] = {name = "Mach Punch", iconItemId = 26934}
MOVES[#MOVES + 1] = {name = "Cosmic Power", iconItemId = 27613}
MOVES[#MOVES + 1] = {name = "Copycat", iconItemId = 27604}
MOVES[#MOVES + 1] = {name = "Seed Bomb", iconItemId = 26971}
MOVES[#MOVES + 1] = {name = "Sky Uppercut", iconItemId = 26952}
MOVES[#MOVES + 1] = {name = "Heal Block", iconItemId = 27614}
MOVES[#MOVES + 1] = {name = "Double Kick", iconItemId = 11708}
MOVES[#MOVES + 1] = {name = "Fissure", iconItemId = 11717}
MOVES[#MOVES + 1] = {name = "Spark", iconItemId = 16326}
MOVES[#MOVES + 1] = {name = "Giga Impact", iconItemId = 12141}
MOVES[#MOVES + 1] = {name = "Aerial Ace", iconItemId = 12070}
MOVES[#MOVES + 1] = {name = "Roost", iconItemId = 17583}
MOVES[#MOVES + 1] = {name = "Absorb", iconItemId = 11692}
MOVES[#MOVES + 1] = {name = "Arm Thrust", iconItemId = 26897}
MOVES[#MOVES + 1] = {name = "Mind Reader", iconItemId = 26936}
MOVES[#MOVES + 1] = {name = "Power-Up Punch", iconItemId = 27589}
MOVES[#MOVES + 1] = {name = "Air Slash", iconItemId = 12033}
MOVES[#MOVES + 1] = {name = "Grass Whistle", iconItemId = 16311}
MOVES[#MOVES + 1] = {name = "Steel Wing", iconItemId = 16328}
MOVES[#MOVES + 1] = {name = "Lovely Kiss", iconItemId = 11735}
MOVES[#MOVES + 1] = {name = "Dig", iconItemId = 27595}
MOVES[#MOVES + 1] = {name = "Bullet Seed", iconItemId = 16302}
MOVES[#MOVES + 1] = {name = "Water Sport", iconItemId = 26959}
MOVES[#MOVES + 1] = {name = "Night Slash", iconItemId = 12087}
MOVES[#MOVES + 1] = {name = "Gastro Acid", iconItemId = 26964}
MOVES[#MOVES + 1] = {name = "Faint Attack", iconItemId = 16672}
MOVES[#MOVES + 1] = {name = "Meowth Super Rocket", iconItemId = 0}
MOVES[#MOVES + 1] = {name = "Gyro Ball", iconItemId = 16675}
MOVES[#MOVES + 1] = {name = "Will-O-Wisp", iconItemId = 11777}
MOVES[#MOVES + 1] = {name = "Disarming Voice", iconItemId = 26908}
MOVES[#MOVES + 1] = {name = "Bite", iconItemId = 11695}
MOVES[#MOVES + 1] = {name = "Charge Beam", iconItemId = 12121}
MOVES[#MOVES + 1] = {name = "U-turn", iconItemId = 26958}
MOVES[#MOVES + 1] = {name = "Silver Wind", iconItemId = 11803}
MOVES[#MOVES + 1] = {name = "Dazzling Gleam", iconItemId = 26906}
MOVES[#MOVES + 1] = {name = "Whirlpool", iconItemId = 27620}
MOVES[#MOVES + 1] = {name = "Meditate", iconItemId = 12119}
MOVES[#MOVES + 1] = {name = "Defense Curl", iconItemId = 11819}
MOVES[#MOVES + 1] = {name = "Aura Sphere", iconItemId = 26899}
MOVES[#MOVES + 1] = {name = "Bug Bite", iconItemId = 11702}
MOVES[#MOVES + 1] = {name = "Brave Bird", iconItemId = 26962}
MOVES[#MOVES + 1] = {name = "Horn Attack", iconItemId = 11724}
MOVES[#MOVES + 1] = {name = "Head Smash", iconItemId = 27616}
MOVES[#MOVES + 1] = {name = "Moonlight", iconItemId = 11821}
MOVES[#MOVES + 1] = {name = "Mega Kick", iconItemId = 11739}
MOVES[#MOVES + 1] = {name = "Thunder Wave", iconItemId = 11809}
MOVES[#MOVES + 1] = {name = "Stealth Rock", iconItemId = 12106}
MOVES[#MOVES + 1] = {name = "Bulldoze", iconItemId = 26931}
MOVES[#MOVES + 1] = {name = "Thunder", iconItemId = 11810}
MOVES[#MOVES + 1] = {name = "Bulk Up", iconItemId = 26902}
MOVES[#MOVES + 1] = {name = "Circle Throw", iconItemId = 26904}
MOVES[#MOVES + 1] = {name = "Powder Snow", iconItemId = 11799}
MOVES[#MOVES + 1] = {name = "Karate Chop", iconItemId = 11731}
MOVES[#MOVES + 1] = {name = "Uproar", iconItemId = 26957}
MOVES[#MOVES + 1] = {name = "Frenzy Plant", iconItemId = 16673}
MOVES[#MOVES + 1] = {name = "Pluck", iconItemId = 26967}
MOVES[#MOVES + 1] = {name = "Submission", iconItemId = 12097}
MOVES[#MOVES + 1] = {name = "Rock Slide", iconItemId = 12764}
MOVES[#MOVES + 1] = {name = "Flatter", iconItemId = 27583}
MOVES[#MOVES + 1] = {name = "Curse", iconItemId = 12111}
MOVES[#MOVES + 1] = {name = "Hammer Arm", iconItemId = 16312}
MOVES[#MOVES + 1] = {name = "Superpower", iconItemId = 12081}
MOVES[#MOVES + 1] = {name = "Metronome", iconItemId = 11796}
MOVES[#MOVES + 1] = {name = "Origin Pulse", iconItemId = 27625}
MOVES[#MOVES + 1] = {name = "Headbutt", iconItemId = 11723}
MOVES[#MOVES + 1] = {name = "Iron Tail", iconItemId = 11729}
MOVES[#MOVES + 1] = {name = "Tackle", iconItemId = 12026}
MOVES[#MOVES + 1] = {name = "Extreme Speed", iconItemId = 17582}
MOVES[#MOVES + 1] = {name = "Flamethrower", iconItemId = 11787}
MOVES[#MOVES + 1] = {name = "Inferno", iconItemId = 12050}
MOVES[#MOVES + 1] = {name = "Haze", iconItemId = 16313}
MOVES[#MOVES + 1] = {name = "Captivate", iconItemId = 12059}
MOVES[#MOVES + 1] = {name = "Discharge", iconItemId = 12076}
MOVES[#MOVES + 1] = {name = "Bounce", iconItemId = 16301}
MOVES[#MOVES + 1] = {name = "Role Play", iconItemId = 27668}
MOVES[#MOVES + 1] = {name = "Tri Attack", iconItemId = 11776}
MOVES[#MOVES + 1] = {name = "Bubblebeam", iconItemId = 11780}
MOVES[#MOVES + 1] = {name = "Zap Cannon", iconItemId = 12109}
MOVES[#MOVES + 1] = {name = "Screech", iconItemId = 16677}
MOVES[#MOVES + 1] = {name = "Hail", iconItemId = 27597}
MOVES[#MOVES + 1] = {name = "Mimic", iconItemId = 11741}
MOVES[#MOVES + 1] = {name = "Icicle Crash", iconItemId = 26927}
MOVES[#MOVES + 1] = {name = "Fairy Wind", iconItemId = 26914}
MOVES[#MOVES + 1] = {name = "Leech Seed", iconItemId = 11733}
MOVES[#MOVES + 1] = {name = "Flash Cannon", iconItemId = 12052}
MOVES[#MOVES + 1] = {name = "Water Gun", iconItemId = 11813}
MOVES[#MOVES + 1] = {name = "Megahorn", iconItemId = 11738}
MOVES[#MOVES + 1] = {name = "Petal Dance", iconItemId = 12045}
MOVES[#MOVES + 1] = {name = "Sacred Fire", iconItemId = 26946}
MOVES[#MOVES + 1] = {name = "Scary Face", iconItemId = 11754}
MOVES[#MOVES + 1] = {name = "Magic Coat", iconItemId = 12139}
MOVES[#MOVES + 1] = {name = "Sketch", iconItemId = 16325}
MOVES[#MOVES + 1] = {name = "Guillotine", iconItemId = 11722}
MOVES[#MOVES + 1] = {name = "Bubble", iconItemId = 11701}
MOVES[#MOVES + 1] = {name = "Assurance", iconItemId = 26898}
MOVES[#MOVES + 1] = {name = "Hyper Beam", iconItemId = 11790}
MOVES[#MOVES + 1] = {name = "Earthquake", iconItemId = 11783}
MOVES[#MOVES + 1] = {name = "Feather Dance", iconItemId = 12069}
MOVES[#MOVES + 1] = {name = "Mega Drain", iconItemId = 11737}
MOVES[#MOVES + 1] = {name = "Flame Charge", iconItemId = 16310}
MOVES[#MOVES + 1] = {name = "Dizzy Punch", iconItemId = 11706}
MOVES[#MOVES + 1] = {name = "Dragon Claw", iconItemId = 27584}
MOVES[#MOVES + 1] = {name = "Jump Kick", iconItemId = 11730}
MOVES[#MOVES + 1] = {name = "Rocket Missile", iconItemId = 0}
MOVES[#MOVES + 1] = {name = "Crush Claw", iconItemId = 12079}
MOVES[#MOVES + 1] = {name = "Lava Plume", iconItemId = 12763}
MOVES[#MOVES + 1] = {name = "Destiny Bond", iconItemId = 26907}
MOVES[#MOVES + 1] = {name = "Bug Buzz", iconItemId = 12057}
MOVES[#MOVES + 1] = {name = "Defog", iconItemId = 27656}
MOVES[#MOVES + 1] = {name = "Metal Claw", iconItemId = 12048}
MOVES[#MOVES + 1] = {name = "Healing Wish", iconItemId = 12083}
MOVES[#MOVES + 1] = {name = "Misty Terrain", iconItemId = 27655}
MOVES[#MOVES + 1] = {name = "Phantom Force", iconItemId = 27592}
MOVES[#MOVES + 1] = {name = "Refresh", iconItemId = 11824}
MOVES[#MOVES + 1] = {name = "Fury Attack", iconItemId = 11718}
MOVES[#MOVES + 1] = {name = "Heart Stamp", iconItemId = 26924}
MOVES[#MOVES + 1] = {name = "Double Slap", iconItemId = 11709}
MOVES[#MOVES + 1] = {name = "Endeavor", iconItemId = 12061}
MOVES[#MOVES + 1] = {name = "Ember", iconItemId = 11714}
MOVES[#MOVES + 1] = {name = "Gunk Shot", iconItemId = 12075}
MOVES[#MOVES + 1] = {name = "Stone Edge", iconItemId = 16329}
MOVES[#MOVES + 1] = {name = "Psycho Cut", iconItemId = 12094}
MOVES[#MOVES + 1] = {name = "Slam", iconItemId = 11758}
MOVES[#MOVES + 1] = {name = "Comet Punch", iconItemId = 13107}
MOVES[#MOVES + 1] = {name = "Focus Energy", iconItemId = 12062}
MOVES[#MOVES + 1] = {name = "Glare", iconItemId = 11721}
MOVES[#MOVES + 1] = {name = "Softboiled", iconItemId = 11826}
MOVES[#MOVES + 1] = {name = "Agility", iconItemId = 11817}
MOVES[#MOVES + 1] = {name = "Mirror Move", iconItemId = 13111}
MOVES[#MOVES + 1] = {name = "Drill Run", iconItemId = 12071}
MOVES[#MOVES + 1] = {name = "Body Slam", iconItemId = 11696}
MOVES[#MOVES + 1] = {name = "Icy Wind", iconItemId = 11793}
MOVES[#MOVES + 1] = {name = "Sleep Talk", iconItemId = 27603}
MOVES[#MOVES + 1] = {name = "Magnitude", iconItemId = 11794}
MOVES[#MOVES + 1] = {name = "Last Resort", iconItemId = 26966}
MOVES[#MOVES + 1] = {name = "Stomp", iconItemId = 11807}
MOVES[#MOVES + 1] = {name = "Needle Arm", iconItemId = 27594}
MOVES[#MOVES + 1] = {name = "Smack Down", iconItemId = 26953}
MOVES[#MOVES + 1] = {name = "Smelling Salts", iconItemId = 27601}
MOVES[#MOVES + 1] = {name = "Thief", iconItemId = 27578}
MOVES[#MOVES + 1] = {name = "Mist", iconItemId = 27599}
MOVES[#MOVES + 1] = {name = "Cotton Guard", iconItemId = 16305}
MOVES[#MOVES + 1] = {name = "Mud Shot", iconItemId = 11742}
MOVES[#MOVES + 1] = {name = "Worry Seed", iconItemId = 12044}
MOVES[#MOVES + 1] = {name = "Spike Cannon", iconItemId = 11765}
MOVES[#MOVES + 1] = {name = "Low Sweep", iconItemId = 26933}
MOVES[#MOVES + 1] = {name = "Swords Dance", iconItemId = 12135}
MOVES[#MOVES + 1] = {name = "Fury Cutter", iconItemId = 16674}
MOVES[#MOVES + 1] = {name = "Sheer Cold", iconItemId = 27600}
MOVES[#MOVES + 1] = {name = "Shell Smash", iconItemId = 26950}
MOVES[#MOVES + 1] = {name = "Synthesis", iconItemId = 12043}
MOVES[#MOVES + 1] = {name = "Mud-Slap", iconItemId = 13112}
MOVES[#MOVES + 1] = {name = "Psychic", iconItemId = 11801}
MOVES[#MOVES + 1] = {name = "Charm", iconItemId = 16304}
MOVES[#MOVES + 1] = {name = "Hurricane", iconItemId = 11814}
MOVES[#MOVES + 1] = {name = "Milk Drink", iconItemId = 16316}
MOVES[#MOVES + 1] = {name = "Fire Spin", iconItemId = 11716}
MOVES[#MOVES + 1] = {name = "Poison Powder", iconItemId = 11798}
MOVES[#MOVES + 1] = {name = "X-Scissor", iconItemId = 12136}
MOVES[#MOVES + 1] = {name = "Leaf Tornado", iconItemId = 12100}
MOVES[#MOVES + 1] = {name = "Thunderbolt", iconItemId = 11774}
MOVES[#MOVES + 1] = {name = "Thunder Shock", iconItemId = 11773}
MOVES[#MOVES + 1] = {name = "Rolling Kick", iconItemId = 12126}
MOVES[#MOVES + 1] = {name = "Rage Powder", iconItemId = 12056}
MOVES[#MOVES + 1] = {name = "Muddy Water", iconItemId = 12138}
MOVES[#MOVES + 1] = {name = "Counter", iconItemId = 15738}
MOVES[#MOVES + 1] = {name = "Clamp", iconItemId = 27623}
MOVES[#MOVES + 1] = {name = "Power Gem", iconItemId = 12088}
MOVES[#MOVES + 1] = {name = "Double-Edge", iconItemId = 11707}
MOVES[#MOVES + 1] = {name = "Pound", iconItemId = 11747}
MOVES[#MOVES + 1] = {name = "Incinerate", iconItemId = 26929}
MOVES[#MOVES + 1] = {name = "Outrage", iconItemId = 12131}
MOVES[#MOVES + 1] = {name = "Poison Sting", iconItemId = 11746}
MOVES[#MOVES + 1] = {name = "Constrict", iconItemId = 12103}
MOVES[#MOVES + 1] = {name = "Nasty Plot", iconItemId = 16317}
MOVES[#MOVES + 1] = {name = "Aromatherapy", iconItemId = 12085}
MOVES[#MOVES + 1] = {name = "Ominous Wind", iconItemId = 16318}
MOVES[#MOVES + 1] = {name = "Clear Smog", iconItemId = 12129}
MOVES[#MOVES + 1] = {name = "Hydro Cannon", iconItemId = 11812}
MOVES[#MOVES + 1] = {name = "Bone Rush", iconItemId = 11698}
MOVES[#MOVES + 1] = {name = "Psycho Shift", iconItemId = 16321}
MOVES[#MOVES + 1] = {name = "Frost Breath", iconItemId = 26920}
MOVES[#MOVES + 1] = {name = "Razor Shell", iconItemId = 12110}
MOVES[#MOVES + 1] = {name = "Overheat", iconItemId = 26941}
MOVES[#MOVES + 1] = {name = "Poison Jab", iconItemId = 12063}
MOVES[#MOVES + 1] = {name = "Triple Kick", iconItemId = 16333}
MOVES[#MOVES + 1] = {name = "Meteor Mash", iconItemId = 11795}
MOVES[#MOVES + 1] = {name = "Double Team", iconItemId = 13108}
MOVES[#MOVES + 1] = {name = "Force Palm", iconItemId = 27587}
MOVES[#MOVES + 1] = {name = "Brutal Swing", iconItemId = 27580}
MOVES[#MOVES + 1] = {name = "Swallow", iconItemId = 17586}
MOVES[#MOVES + 1] = {name = "Stun Spore", iconItemId = 11808}
MOVES[#MOVES + 1] = {name = "Snore", iconItemId = 11763}
MOVES[#MOVES + 1] = {name = "Dragon Tail", iconItemId = 12762}
MOVES[#MOVES + 1] = {name = "Thunder Punch", iconItemId = 11772}
MOVES[#MOVES + 1] = {name = "Peck", iconItemId = 12132}
MOVES[#MOVES + 1] = {name = "Pin Missile", iconItemId = 11744}
MOVES[#MOVES + 1] = {name = "Safeguard", iconItemId = 12124}
MOVES[#MOVES + 1] = {name = "Rage", iconItemId = 12065}
MOVES[#MOVES + 1] = {name = "Harden", iconItemId = 11820}
MOVES[#MOVES + 1] = {name = "Play Rough", iconItemId = 26943}
MOVES[#MOVES + 1] = {name = "Precipice Blade", iconItemId = 27596}
MOVES[#MOVES + 1] = {name = "Knock Off", iconItemId = 26973}
MOVES[#MOVES + 1] = {name = "Petal Blizzard", iconItemId = 26942}
MOVES[#MOVES + 1] = {name = "Fake Tears", iconItemId = 27582}
MOVES[#MOVES + 1] = {name = "Poison Fang", iconItemId = 11745}
MOVES[#MOVES + 1] = {name = "Calm Mind", iconItemId = 11818}
MOVES[#MOVES + 1] = {name = "Wish", iconItemId = 16334}
MOVES[#MOVES + 1] = {name = "Quick Attack", iconItemId = 11749}
MOVES[#MOVES + 1] = {name = "Twineedle", iconItemId = 12067}
MOVES[#MOVES + 1] = {name = "Dive", iconItemId = 27621}
MOVES[#MOVES + 1] = {name = "Poison Tail", iconItemId = 27611}
MOVES[#MOVES + 1] = {name = "Ice Fang", iconItemId = 12142}
MOVES[#MOVES + 1] = {name = "Focus Punch", iconItemId = 13109}
MOVES[#MOVES + 1] = {name = "Icicle Spear", iconItemId = 26928}
MOVES[#MOVES + 1] = {name = "Fire Punch", iconItemId = 11715}
MOVES[#MOVES + 1] = {name = "Punishment", iconItemId = 16676}
MOVES[#MOVES + 1] = {name = "Dragon Rush", iconItemId = 26910}
MOVES[#MOVES + 1] = {name = "Psystrike", iconItemId = 26944}
MOVES[#MOVES + 1] = {name = "Memento", iconItemId = 27581}
MOVES[#MOVES + 1] = {name = "Pursuit", iconItemId = 12064}
MOVES[#MOVES + 1] = {name = "Dragon Rage", iconItemId = 15797}
MOVES[#MOVES + 1] = {name = "Shock Wave", iconItemId = 16324}
MOVES[#MOVES + 1] = {name = "Psybeam", iconItemId = 11800}
MOVES[#MOVES + 1] = {name = "Surf", iconItemId = 27624}
MOVES[#MOVES + 1] = {name = "Shadow Punch", iconItemId = 11757}
MOVES[#MOVES + 1] = {name = "Reflect", iconItemId = 12095}
MOVES[#MOVES + 1] = {name = "Sing", iconItemId = 11804}
MOVES[#MOVES + 1] = {name = "Sludge Wave", iconItemId = 12104}
MOVES[#MOVES + 1] = {name = "Twister", iconItemId = 12068}
MOVES[#MOVES + 1] = {name = "Extrasensory", iconItemId = 16309}
MOVES[#MOVES + 1] = {name = "Zen Headbutt", iconItemId = 13115}
MOVES[#MOVES + 1] = {name = "Mirror Shot", iconItemId = 12108}
MOVES[#MOVES + 1] = {name = "Rock Throw", iconItemId = 11753}
MOVES[#MOVES + 1] = {name = "Earth Power", iconItemId = 12080}
MOVES[#MOVES + 1] = {name = "Wrap", iconItemId = 13114}
MOVES[#MOVES + 1] = {name = "Rock Climb", iconItemId = 27661}
MOVES[#MOVES + 1] = {name = "Foul Play", iconItemId = 26918}
MOVES[#MOVES + 1] = {name = "Shadow Claw", iconItemId = 26949}
MOVES[#MOVES + 1] = {name = "Rollout", iconItemId = 12032}
MOVES[#MOVES + 1] = {name = "Wring Out", iconItemId = 12105}
MOVES[#MOVES + 1] = {name = "Psycho Boost", iconItemId = 27612}
MOVES[#MOVES + 1] = {name = "Light Screen", iconItemId = 26932}
MOVES[#MOVES + 1] = {name = "Water Pulse", iconItemId = 12055}
MOVES[#MOVES + 1] = {name = "Scratch", iconItemId = 11755}
MOVES[#MOVES + 1] = {name = "Hi Jump Kick", iconItemId = 12125}
MOVES[#MOVES + 1] = {name = "Volt Switch", iconItemId = 27586}
MOVES[#MOVES + 1] = {name = "Dynamic Punch", iconItemId = 11712}
MOVES[#MOVES + 1] = {name = "Doom Desire", iconItemId = 27618}
MOVES[#MOVES + 1] = {name = "Leech Life", iconItemId = 11732}
--MOVES[#MOVES + 1] = {name = "Whirlwind", iconItemId = 12026}
MOVES[#MOVES + 1] = {name = "Reversal", iconItemId = 11751}
MOVES[#MOVES + 1] = {name = "Rock Blast", iconItemId = 11752}
MOVES[#MOVES + 1] = {name = "Quick Guard", iconItemId = 27653}
MOVES[#MOVES + 1] = {name = "Sweet Kiss", iconItemId = 16331}
MOVES[#MOVES + 1] = {name = "Signal Beam", iconItemId = 12140}
MOVES[#MOVES + 1] = {name = "Facade", iconItemId = 26913}
MOVES[#MOVES + 1] = {name = "Nuzzle", iconItemId = 27585}
MOVES[#MOVES + 1] = {name = "Wing Attack", iconItemId = 11815}
MOVES[#MOVES + 1] = {name = "Ice Punch", iconItemId = 11728}
MOVES[#MOVES + 1] = {name = "Thunder Fang", iconItemId = 12143}
MOVES[#MOVES + 1] = {name = "Tailwind", iconItemId = 12060}
MOVES[#MOVES + 1] = {name = "Grass Knot", iconItemId = 26921}
MOVES[#MOVES + 1] = {name = "Wake-Up Slap", iconItemId = 12082}
MOVES[#MOVES + 1] = {name = "Drain Punch", iconItemId = 16671}
MOVES[#MOVES + 1] = {name = "Fly", iconItemId = 27590}
MOVES[#MOVES + 1] = {name = "Focus Blast", iconItemId = 26916}
MOVES[#MOVES + 1] = {name = "Barrier", iconItemId = 12133}
MOVES[#MOVES + 1] = {name = "Sky Drop", iconItemId = 26951}
MOVES[#MOVES + 1] = {name = "Mud Sport", iconItemId = 26939}
MOVES[#MOVES + 1] = {name = "Super Fang", iconItemId = 26955}
MOVES[#MOVES + 1] = {name = "Sludge", iconItemId = 11761}
MOVES[#MOVES + 1] = {name = "Close Combat", iconItemId = 12091}
MOVES[#MOVES + 1] = {name = "Aqua Ring", iconItemId = 16300}
MOVES[#MOVES + 1] = {name = "Magical Leaf", iconItemId = 12134}
MOVES[#MOVES + 1] = {name = "Conversion2", iconItemId = 17581}
MOVES[#MOVES + 1] = {name = "Struggle Bug", iconItemId = 26972}
MOVES[#MOVES + 1] = {name = "Wild Charge", iconItemId = 26960}
MOVES[#MOVES + 1] = {name = "Night Shade", iconItemId = 11743}
MOVES[#MOVES + 1] = {name = "Nightmare", iconItemId = 12114}
MOVES[#MOVES + 1] = {name = "Aqua Tail", iconItemId = 12051}
MOVES[#MOVES + 1] = {name = "Slash", iconItemId = 11759}
MOVES[#MOVES + 1] = {name = "Magnet Rise", iconItemId = 26935}
MOVES[#MOVES + 1] = {name = "Iron Defense", iconItemId = 27619}
MOVES[#MOVES + 1] = {name = "Secret Power", iconItemId = 26948}
MOVES[#MOVES + 1] = {name = "Sucker Punch", iconItemId = 12118}
MOVES[#MOVES + 1] = {name = "Roar", iconItemId = 26945}
MOVES[#MOVES + 1] = {name = "Dragon Pulse", iconItemId = 16306}
MOVES[#MOVES + 1] = {name = "Spider Web", iconItemId = 16327}
MOVES[#MOVES + 1] = {name = "Splash", iconItemId = 11766}
MOVES[#MOVES + 1] = {name = "Spit Up", iconItemId = 17584}
MOVES[#MOVES + 1] = {name = "Hydro Pump", iconItemId = 11789}
MOVES[#MOVES + 1] = {name = "Spite", iconItemId = 12117}
MOVES[#MOVES + 1] = {name = "Nature Power", iconItemId = 27662}
MOVES[#MOVES + 1] = {name = "Spore", iconItemId = 11767}
MOVES[#MOVES + 1] = {name = "Stockpile", iconItemId = 17585}
MOVES[#MOVES + 1] = {name = "Take Down", iconItemId = 11771}
MOVES[#MOVES + 1] = {name = "Low Kick", iconItemId = 11736}
MOVES[#MOVES + 1] = {name = "Revenge", iconItemId = 12099}
MOVES[#MOVES + 1] = {name = "Sand-Attack", iconItemId = 12034}
MOVES[#MOVES + 1] = {name = "Fury Swipes", iconItemId = 11719}
MOVES[#MOVES + 1] = {name = "Flame Burst", iconItemId = 12047}
MOVES[#MOVES + 1] = {name = "Reflect Type", iconItemId = 26969}
MOVES[#MOVES + 1] = {name = "Sky Attack", iconItemId = 15741}
MOVES[#MOVES + 1] = {name = "Ice Ball", iconItemId = 27598}
MOVES[#MOVES + 1] = {name = "Recover", iconItemId = 11823}
MOVES[#MOVES + 1] = {name = "Shadow Sneak", iconItemId = 16323}
MOVES[#MOVES + 1] = {name = "Ice Shard", iconItemId = 13110}
MOVES[#MOVES + 1] = {name = "Razor Wind", iconItemId = 15740}
MOVES[#MOVES + 1] = {name = "Mirror Coat", iconItemId = 12122}

local MOVE_BY_ICON_ITEM_ID = {}
for k, v in pairs(MOVES) do
    MOVE_BY_ICON_ITEM_ID[v.iconItemId] = v
end

function getMoveNameByIconItemId(iconItemId)
    return MOVE_BY_ICON_ITEM_ID[iconItemId] and MOVE_BY_ICON_ITEM_ID[iconItemId].name or ""
end

local MOVES_DESCRIPTIONS = {
    --[[["Protect"] = "Protect raises the user's Defense by two stages.",
    ["Present"] = "Present has two different effects. Present can either deal damage against the target or heal the target.",
    ["Cross Chop"] = "Cross Chop deals damage and has an increased critical hit ratio.",
    ["Fire Fang"] = "Fire Fang deals damage and has a 10%% chance of burning the target, plus a 10%% chance of causing the target to flinch.",
    ["Skull Bash"] = "Increases Defense on first turn, attacks on second turn.",
    ["Cotton Guard"] = "Cotton Guard raises the user's Defense stat by three stages.",
    ["String Shot"] = "String Shot lowers the target's Speed by one stage.",
    ["Leaf Blade"] = "Leaf Blade deals damage and has an increased critical hit ratio.",
    ["Quiver Dance"] = "Quiver Dance raises the user's Special Attack, Special Defense and Speed by one stage each.",
    ["Hypnosis"] = "Hypnosis puts the target to sleep.",
    ["Thrash"] = "The user attacks for 2-3 turns and then becomes confused.",
    ["Rain Dance"] = "Raind Dance raises the user's Attack and Defense by one stage.",
    ["Transform"] = "User takes on the form and attacks of the opponent.",
    ["Air Cutter"] = "Air Cutter deals damage and has an increased critical hit ratio.",
    ["Iron Head"] = "Iron Head inflicts damage and has a 30%% chance of causing the target to flinch.",
    ["Bone Club"] = "Bone Club deals damage and has a 10%% chance of causing the target to flinch.",
    ["Psywave"] = "Psywave inflicts a random amount of HP damage, varying by user's level.",
    ["Hex"] = "Hex inflicts damage, but if the target has a status ailment (i.e. is burned, poisoned, paralyzed, asleep or frozen) it will double in power.",
    ["Rolling Kick"] = "Rolling Kick deals damage and has a 30%% chance of causing the target to flinch.",
    ["Double-Edge"] = "Double-Edge deals damage and has no secondary effect.",
    ["Acid"] = "Acid deals damage and has a 10%% chance of lowering the target's Special Defense by one stage.",
    ["Crabhammer"] = "Crabhammer deals damage and has an increased critical hit ratio.",
    ["Metal Sound"] = "Metal Sound lowers the target's Special Defense by two stages.",
    ["Toxic Spikes"] = "Toxic Spikes deals damage and inflicts Poison, if the target already is Poisoned then inflicits Badly Poison.",
    ["Dream Eater"] = "Dream Eater deals damage only on sleeping foes and the user will recover 50%% of the HP drained.",
    ["Mud Shot"] = "Mud Shot deals damage and lowers the target's Speed by one stage.",
    ["Shadow Ball"] = "Shadow Ball deals damage and has a 20%% chance of lowering the target's Special Defense by one stage.",
    ["Egg Bomb"] = "Egg Bomb inflicts damage and has no secondary effect.",
    ["Substitute"] = "Creates a replacement who will take all the damage. During this the user can't use any move.",
    ["Payback"] = "Any move is reflected back to the attacker.",
    ["Absorb"] = "Absorb deals damage and the user will recover 50%% of the HP drained.",
    ["Pin Missile"] = "Pin Missile inflicts damage, hitting the target between 2-5 times per use.",
    ["Cross Poison"] = "Cross Poison deals damage and has a 10%% chance of poisoning the target. It also has an increased critical hit ratio.",
    ["Ancient Power"] = "Ancient Power inflicts damage and has a 10%% chance of raising all of the user's stats by one stage.",
    ["Leaf Storm"] = "Leaf Storm deals damage but lowers the user's Special Attack by two stages after attacking.",
    ["Disable"] = "Disable causes the previous move the target used to be disabled for 100 seconds. If the target has not used any move, then will be random.",
    ["Hyper Fang"] = "Hyper Fang deals damage and has a 10%% chance of causing the target to flinch.",
    ["Bonemerang"] = "Bonemerang inflicts damage, hitting the target 2 times per use.",
    ["Charge Beam"] = "Charge Beam deals damage and has a 70%% chance of raising the user's Special Attack by one stage.",
    ["Vital Throw"] = "Vital Throw deals damage and ignores changes to the Accuracy and Evasion stats.",
    ["Swift"] = "Swift deals damage and ignores changes to the Accuracy and Evasion stats.",
    ["Sonic Boom"] = "Sonic Boom deals damage and has no secondary effect.",
    ["Rock Tomb"] = "Rock Tomb does damage and lowers the opponent's speed one stage.",
    ["Supersonic"] = "Supersonic causes the target to become confused.",
    ["Selfdestruct"] = "Resembling a weaker version of Explosion, Selfdestruct inflicts damage, and causes the user to faint.",
    ["Rapid Spin"] = "Rapid Spin deals a small amount of damage and removes the effects of several 'trap' moves.",
    ["Stored Power"] = "Stored Power deals variable damage depending on the stat modifications of the user. When the user has no stat modifications, Stored Power's base power is 20. Its power increases by 20 for each stat boost the user has.",
    ["Meditate"] = "Meditate raises the user's Attack by one stage.",
    ["Rest"] = "User sleeps for 5 seconds, but user is fully healed.",
    ["Bullet Punch"] = "Bullet Punch deals damage.",
    ["Charge"] = "If the user's next move is Electric-type, its base power will be doubled. Charge also raises the user's Special Defense by one stat level.",
    ["Confuse Ray"] = "Confuse Ray causes the target to become confused.",
    ["Blizzard"] = "Blizzard deals damage and has a 10%% chance of freezing the opponent.",
    ["Mist Ball"] = "Mist Ball inflicts damage and has a 50%% chance of lowering the target's Special Attack.",
    ["Hyper Voice"] = "Hyper Voice inflicts damage and has no secondary effect.",
    ["Mega Kick"] = "Mega Kick deals damage and has no secondary effect.",
    ["Mirror Move"] = "Mirror Move copies the target's last move. If there isn't a last move, copy random.",
    ["Toxic"] = "Toxic causes the target to be badly poisoned.",
    ["Acrobatics"] = "Acrobatics deals damage and has no secondary effect.",
    ["Electroweb"] = "Electroweb inflicts damage and then lowers the target's Speed stat by one stage.",
    ["Ice Beam"] = "Ice Beam inflicts damage and has a 10%% chance of freezing the target.",
    ["Amnesia"] = "Amnesia raises the user's Special Defense by two stages.",
    ["Acid Spray"] = "Acid Spray inflicts damage and lowers the target's Special Defense by two stages.",
    ["Drill Peck"] = "Drill Peck inflicts damage and has no secondary effect.",
    ["Double Hit"] = "Double Hit hits twice in one turn.",
    ["Revenge"] = "Revenge charge during 5 turns and then deals damage.",
    ["Mud Bomb"] = "Mud Bomb deals damage and has a 30%% chance of lowering the target's Accuracy by one stage.",
    ["Sleep Powder"] = "Sleep Powder puts the target to sleep.",
    ["Electro Ball"] = "Electro Ball deals damage and has no secondary effect.",
    ["Sand Tomb"] = "Sand Tomb inflicts damage, hiting the target 5 times per use and lower the Speed of the target by two stages.",
    ["Smoke Screen"] = "Smoke Screen lowers the target's Accuracy by one stage.",
    ["Power Whip"] = "Power Whip inflicts damage and has no secondary effect.",
    ["Razor Leaf"] = "Razor Leaf deals damage and has an increased critical hit ratio.",
    ["Mega Punch"] = "Mega Punch deals damage and has no secondary effect.",
    ["Confusion"] = "Confusion deals damage and has a 10%% chance of confusing the target.",
    ["Flame Burst"] = "Flame Burst deals damage and has no secondary effect.",
    ["Venoshock"] = "Venoshock inflicts damage and its power will double to 130 when the target is poisoned.",
    ["Acid Armor"] = "Acid Armor raises the user's Defense by two stages.",
    ["Horn Drill"] = "Horn Drill deals damage and has no secondary effect.",
    ["Flare Blitz"] = "Flare Blitz will thaw out the user if it is frozen, and then inflict damage on the target.",
    ["Vine Whip"] = "Vine Whip inflicts damage and has no secondary effect.",
    ["Seismic Toss"] = "Seismic Toss deals damage and has no secondary effect.",
    ["Solar Beam"] = "Solar Beam deals damage but the user can't attack on the next turn.",
    ["Flame Wheel"] = "Flame Wheel will thaw out the user if it is frozen, and then inflict damage on the target. Flame Wheel also has a 10%% chance of burning the target.",
    ["Smog"] = "Smog inflicts damage and has a 40%% chance of poisoning the target.",
    ["Brick Break"] = "Brick Break deals damage, but removes the effects of Reflect before attacking.",
    ["Coil"] = "Coil raises the user's Attack, Defense by by one stage each and clear Accuracy .",
    ["Bide"] = "The user of Bide 'stores energy' for 2 turns. At the end of the second turn the Pokemon 'unleashes energy', dealing twice the HP damage it received.",
    ["Dragon Dance"] = "Dragon Dance raises the user's Attack and Speed by one stage each.",
    ["Yawn"] = "In the turn that Yawn is used, the only effect will be the user yawning at the target. At the end of the next turn, the target (if still active) will fall asleep unless it gets affected by a major status condition in the meantime, a status-protecting move is used (like Safeguard or Uproar), or the battle ends.",
    ["Eruption"] = "Eruption does damage proportionately based on the user's HP. This move's base power reduces as the user's HP reduces and is calculated by the formula: Power = 150 x current HP / maximum HP. Hence, at maximum HP (100%% HP), the move's base power would be 150.",
    ["Double Kick"] = "Double Kick inflicts damage, hitting the target 2 times per use.",
    ["Fissure"] = "Fissure deals damage and has no secondary effect.",
    ["Spark"] = "Spark inflicts damage and has a 30%% chance of paralyzing the target.",
    ["Roost"] = "User recovers half of its max HP. Flying types temporarily lose Ground type immunity.",
    ["Power Gem"] = "Power Gem inflicts damage and has no secondary effect.",
    ["Grass Whistle"] = "Grass Whistle puts the target to sleep.",
    ["Night Slash"] = "Night Slash deals damage and has an increased critical hit ratio.",
    ["Peck"] = "Peck inflicts damage and has no secondary effect.",
    ["Faint Attack"] = "Faint Attack deals damage and ignores changes to the Accuracy and Evasion stats.",
    ["Meowth Super Rocket"] = "",
    ["Gyro Ball"] = "Gyro Ball deals damage and has no secondary effect.",
    ["Psycho Cut"] = "Psycho Cut deals damage and has an increased critical hit ratio.",
    ["Bite"] = "Bite deals damage and has a 30%% chance of causing the target to flinch.",
    ["Silver Wind"] = "Silver Wind deals damage and has a 10%% chance of raising the user's Attack, Defense, Special Attack, Special Defense and Speed by one stage each.",
    ["Bug Bite"] = "Bug Bite deals damage and has no secondary effect.",
    ["Horn Attack"] = "Horn Attack deals damage and has no secondary effect.",
    ["Refresh"] = "Cures paralysis, poison, and burns.",
    ["Thunder Wave"] = "Thunder Wave paralyzes the target. Thunder Wave will not work against Ground types.",
    ["Stealth Rock"] = "Stealth Rock deals damage and lower the Speed of the target by two stages.",
    ["Fury Swipes"] = "Fury Swipes inflicts damage, hitting 2-5 times per use.",
    ["Powder Snow"] = "Powder Snow inflicts damage and has a 10%% chance of freezing the target.",
    ["Frenzy Plant"] = "Frenzy Plant deals damage but the user can't attack on the next turn.",
    ["Submission"] = "Submission deals damage and has no secondary effect.",
    ["Rock Slide"] = "Rock Slide deals damage and has a 30%% chance of causing the target to flinch.",
    ["Punishment"] = "Punishment deals varying damage based on the opponent's stat increases. It starts at base power 60 and increases by 20 for every net stat boost of the opponent.",
    ["Hammer Arm"] = "Hammer Arm does damage, then lowers the user's Speed by one level.",
    ["Superpower"] = "Superpower deals damage but lowers the user's Attack and Defense by one stage each after attacking.",
    ["Tailwind"] = "Tailwind doubles the speed of all Pokemon in the user's party for 10 seconds.",
    ["Tackle"] = "Tackle is one of the most common and basic moves a Pokemon learns. It deals damage with no additional effects.",
    ["Extreme Speed"] = "Extreme Speed deals damage and has no secondary effect.",
    ["Flamethrower"] = "Flamethrower deals damage and has a 10%% chance of burning the target.",
    ["Inferno"] = "Inferno deals damage and will always burn the target if it hits.",
    ["Tri Attack"] = "Tri Attack deals damage and has a 20%% chance of paralyzing, burning or freezing the target - i.e. a 6.67%% chance of each status condition.",
    ["Zap Cannon"] = "Zap Cannon deals damage and paralyzes the target.",
    ["Mimic"] = "Mimic copies the target's last move. If there isn't a last move, copy random.",
    ["Sludge"] = "Sludge does damage and has a 30%% chance of poisoning the target.",
    ["Water Gun"] = "Water Gun inflicts damage and has no secondary effect.",
    ["Megahorn"] = "Megahorn deals damage and has no secondary effect.",
    ["Steel Wing"] = "Steel Wing inflicts damage and has a 10%% chance of raising the user's Defense.",
    ["Guillotine"] = "Guillotine deals damage and has no secondary effect.",
    ["Bubble"] = "Bubble deals damage and has a 10%% chance of lowering the target's Speed by one stage.",
    ["Psychic"] = "Psychic deals damage and has a 10%% chance of lowering the target's Special Defense by one stage.",
    ["Hyper Beam"] = "Hyper Beam deals damage but the user can't attack on the next turn.",
    ["Earthquake"] = "Earthquake deals damage.",
    ["Feather Dance"] = "Feather Dance lowers the target's Attack by two stages.",
    ["Bubblebeam"] = "Bubblebeam deals damage and has a 10%% chance of lowering the target's Speed by one stage.",
    ["Discharge"] = "Discharge deals damage and has a 30%% chance of paralyzing the target(s).",
    ["Captivate"] = "Captivate lowers the Special Attack of the target by two stages, if they are of the opposite gender to the user.",
    ["Jump Kick"] = "Jump Kick deals damage and has no secondary effect.",
    ["Lava Plume"] = "Lava Plume deals damage and has 30%% of chance to burn the target.",
    ["Healing Wish"] = "The user become with 1 HP and all party members recover full HP.",
    ["Double Slap"] = "Double Slap inflicts damage and hits between 2-5 times per use.",
    ["Endeavor"] = "Endeavor deals damage and has no secondary effect.",
    ["Ember"] = "Ember does damage and has a 10%% chance of burning the target.",
    ["Gunk Shot"] = "Gunk Shot deals damage and has a 30%% chance of poisoning the target.",
    ["Reversal"] = "Reversal deals more damage the lower the target HP.",
    ["Softboiled"] = "User recovers 50%% of its max HP.",
    ["Agility"] = "Agility raises the user's Speed by two stages.",
    ["Drill Run"] = "Drill Run deals damage and has an increased critical hit ratio.",
    ["Icy Wind"] = "Icy Wind deals damage and lowers the target's Speed by one stage.",
    ["Stomp"] = "Stomp deals damage and has a 30%% chance of causing the target to flinch.",
    ["Leech Seed"] = "Leech Seed plants a seed on the target. At the end of each turn that the target is under the effect of Leech Seed, the target's HP will be drained, and the same amount of HP will be restored to the target's opponent. Leech Seed will not work against Grass-type Pokemon.",
    ["Worry Seed"] = "Worry Seed inflicits an Insonia to the target. With this effect, the target Pokemon cannot sleep and wakes up if already asleep.",
    ["Spike Cannon"] = "Spike Cannon inflicts damage, hitting the target 2-5 times per use.",
    ["Swords Dance"] = "Swords Dance raises the user's Attack by two stages.",
    ["Leaf Tornado"] = "Leaf Tornado deals damage and has a 30%% chance of lowering the target's Accuracy by one stage.",
    ["Earth Power"] = "Earth Power deals damage and has a 10%% chance of lowering the target's Special Defense by one stage.",
    ["Charm"] = "Charm lowers the Attack stat of the target by two stages.",
    ["Hurricane"] = "Hurricane deals damage and has a 30%% chance of confusing the target.",
    ["Milk Drink"] = "Milk Drink restores up to 50%% of the user's current HP.",
    ["Fire Spin"] = "Fire Spin does damage and lower the target's Speed by two stages.",
    ["Poison Powder"] = "Poison Powder poisons the target.",
    ["X-Scissor"] = "X-Scissor deals damage and has no secondary effect.",
    ["Thunderbolt"] = "Thunderbolt does damage and has a 10%% chance of paralyzing the target.",
    ["Thunder Shock"] = "Thunder Shock inflicts damage and has a 10%% chance of paralyzing the target.",
    ["Gust"] = "Gust deals damage and has no secondary effect.",
    ["Outrage"] = "User attacks for 2-3 turns and then becomes confused.",
    ["Muddy Water"] = "Muddy Water deals damage and has a 30%% chance of lowering the target's Accuracy by one stage.",
    ["Counter"] = "When hit by a Physical Attack, user strikes back with 2x power.",
    ["Recover"] = "User recovers 50%% of its max HP.",
    ["Ice Fang"] = "Ice Fang deals damage and has a 10%% chance of freezing the target, plus a 10%% chance of causing the target to flinch.",
    ["Heal Pulse"] = "Heal Pulse recover party members HP.",
    ["Pound"] = "Pound inflicts damage and has no secondary effect.",
    ["Metal Claw"] = "Metal Claw deals damage and has a 10%% chance of raising the user's Attack by one stage.",
    ["Body Slam"] = "Body Slam deals damage and has a 30%% chance of paralyzing the target.",
    ["Thunder"] = "Thunder deals damage and has a 30%% chance of paralyzing the target.",
    ["Poison Sting"] = "Poison Sting inflicts damage and has a 30%% chance of poisoning the target.",
    ["Fire Blast"] = "Fire Blast inflicts damage and has a 10%% chance of burning the target.",
    ["Drain Punch"] = "Drain Punch deals damage and the user will recover 50%% of the HP drained.",
    ["Ominous Wind"] = "Ominous Wind inflicts damage and has a 10%% chance of raising all of the user's stats by one stage.",
    ["Clear Smog"] = "Clear Smog inflicts damage and resets all stat levels of the target to 0.",
    ["Brine"] = "Brine inflicts damage, and its power doubles to 130 when the target is at or below 50%% health.",
    ["Bone Rush"] = "Bone Rush inflicts damage, hitting the target 2-5 times per use.",
    ["Psycho Shift"] = "Psycho Shift transfers any non-volatile status ailment from the user to the target, curing the user in the process. It will not transfer volatile status ailments (confusion, etc.).",
    ["Lick"] = "Lick deals damage and has a 30%% chance of paralyzing the target.",
    ["Rage Powder"] = "Rage Powder redirects all single-target opponents to itself.",
    ["Swallow"] = "Swallow recovers a varying amount of HP depending on how many times the user has used Stockpile. It recovers 25%%, 50%% or 100%% of the user's maximum HP if the user stockpiled one, two or three times respectively.",
    ["Razor Shell"] = "Razor Shell deals damage and has a 50%% chance of lowering the target's Defense by one stage.",
    ["Triple Kick"] = "Triple Kick deals damage and has no secondary effect.",
    ["Will-O-Wisp"] = "Will-O-Wisp inflicts a burn on the target. It has no effect on Fire-type Pokemon.",
    ["Double Team"] = "Double Team increases the user's speed into maximum, creating illusions.",
    ["Explosion"] = "Explosion deals high damage, but causes the user to faint.",
    ["Petal Dance"] = "The user attacks for 2-3 turns and then becomes confused.",
    ["Hydro Cannon"] = "Hydro Cannon deals damage but the user can't attack on the next turn.",
    ["Stun Spore"] = "Stun Spore paralyzes the target.",
    ["Snore"] = "Snore can only be used whilst the user is sleeping and will fail if the user is not.",
    ["Ally Switch"] = "Change position with target.",
    ["Thunder Punch"] = "Thunder Punch does damage and has a 10%% chance of paralyzing the opponent.",
    ["Poison Gas"] = "Poison Gas poisons the target. It will fail if the target is Poison or Steel-type.",
    ["Aurora Beam"] = "Aurora Beam deals damage and has a 10%% chance of lowering the target's Attack by one stage.",
    ["Safeguard"] = "The user's party is protected from status conditions.",
    ["Rage"] = "Rage inflicts damage, hitting the target 2-5 times per use.",
    ["Harden"] = "Harden raises the user's Defense by one stage.",
    ["Quick Attack"] = "Quick Attack deals damage and has no secondary effect.",
    ["Dragon Tail"] = "Dragon Tail deals damage and has no secondary effect.",
    ["Psybeam"] = "Psybeam deals damage and has a 10%% chance of confusing the target.",
    ["Meteor Mash"] = "Meteor Mash deals damage and has a 20%% chance of raising the user's Attack by one stage.",
    ["Extrasensory"] = "Extrasensory inflicts damage and has a 10%% chance of causing the target to flinch.",
    ["Dynamic Punch"] = "Dynamic Punch inflicts damage and confuses the target.",
    ["Calm Mind"] = "Calm Mind raises the user's Special Attack and Special Defense by one stage each.",
    ["Wish"] = "The turn Wish is used, the user will make a wish. At the end of the next turn, the Pokemon will be healed by half its own maximum HP.",
    ["Nasty Plot"] = "Nasty Plot raises the user's Special Attack stat by two stages.",
    ["Twineedle"] = "Twineedle deals damage and will strike twice (with 25 base power each time). It has a 20%% chance of poisoning the target, except for Poison or Steel types which cannot be poisoned.",
    ["Spider Web"] = "Spider Web paralyzes the target.",
    ["Bug Buzz"] = "Bug Buzz deals damage and has a 10%% chance of lowering the target's Special Defense by one stage.",
    ["Dragon Rage"] = "Dragon Rage deals damage and has no secondary effect.",
    ["Focus Punch"] = "Focus Punch charge during 5 turns and then deals damage.",
    ["Future Sight"] = "Future Sight deals damage, but does not hit until two turns after the move is selected.",
    ["Rock Blast"] = "Rock Blast inflicts damage, hitting the target 2-5 times per use.",
    ["Stone Edge"] = "Stone Edge deals damage and has an increased critical hit ratio.",
    ["Moonlight"] = "Moonlight restores the user's current HP based on the weather conditions and time of day. Normal conditions will restore 1/2 of the total HP.",
    ["Mega Drain"] = "Mega Drain inflicts damage, and 50%% of the damage dealt to the target is restored to the user. The amount of HP recovered is always rounded down.",
    ["Fury Cutter"] = "Fury Cutter deals damage and has no secondary effect.",
    ["Rocket Missile"] = "",
    ["Magic Coat"] = "Any move is reflected back to the attacker.",
    ["Rollout"] = "Rollout inflicts damage over five turns and raises the user's Speed by two stages.",
    ["Close Combat"] = "Close Combat deals damage but lowers the user's Defense and Special Defense by one stage each after attacking.",
    ["Magnitude"] = "Magnitude does not have a set base power. Instead the base power of this move varies on a magnitude scale between four and ten.",
    ["Flash Cannon"] = "Flash Cannon deals damage and has a 10%% chance of lowering the target's Special Defense by one stage.",
    ["Mud-Slap"] = "Mud-Slap deals damage and lowers the target's Accuracy by one stage.",
    ["Giga Drain"] = "Giga Drain deals damage and the user will recover 50%% of the HP drained.",
    ["Focus Energy"] = "Increases Critical-Hit ratio by 50%%.",
    ["Twister"] = "Twister deals damage and has a 30%% chance of causing the target to flinch.",
    ["Constrict"] = "Constrict deals damage and has a 10%% chance of lowering the target's Speed by one stage.",
    ["Wood Hammer"] = "Tickle reduces the target's Attack and Defense stat by one stat level each.",
    ["Mirror Shot"] = "Mirror Shot deals damage and has a 30%% chance of lowering the target's Accuracy by one stage.",
    ["Rock Throw"] = "Rock Throw deals damage and has no secondary effect.",
    ["Slash"] = "Slash deals damage and has an increased critical hit ratio.",
    ["Wrap"] = "Wrap deals damage and lower the Speed of the target by two stages.",
    ["Scratch"] = "Scratch inflicts damage and has no secondary effect.",
    ["Crunch"] = "Crunch deals damage and has a 20%% chance of lowering the target's Defense by one stage.",
    ["Screech"] = "Screech lowers the target's Defense by two stages.",
    ["Fury Attack"] = "Fury Attack does damage, hitting 2-5 times per use.",
    ["Wring Out"] = "The power of Wring Out varies between 1 and 120 depending on how much HP the opponent has. The more HP the opponent has, the more damage this move will do. Its damage is calculated by the following formula: Base Power = 120 x (Opponent's Current HP/Opponent's Maximum HP)",
    ["Fire Punch"] = "Fire Punch does damage and has a 10%% chance of burning the target.",
    ["Reflect"] = "Any move is reflected back to the attacker.",
    ["Water Pulse"] = "Water Pulse deals damage and has a 20%% chance of confusing the target.",
    ["Shock Wave"] = "Shock Wave inflicts damage and is unaffected by modifications to the Accuracy stat and Evasion stat.",
    ["Lovely Kiss"] = "Lovely Kiss causes the target to fall asleep.",
    ["Haze"] = "Resets all stat changes.",
    ["Flame Charge"] = "Flame Charge inflicts damage and raises the user's Speed by one level.",
    ["Dizzy Punch"] = "Dizzy Punch deals damage and has a 20%% chance of confusing the target.",
    ["Leech Life"] = "Leech Life inflicts damage, and up to 50%% of the damage dealt to the target is restored to the user as HP.",
    ["Sing"] = "Sing puts the target to sleep.",
    ["Karate Chop"] = "Karate Chop deals damage and has an increased critical hit ratio.",
    ["Conversion2"] = "Changes the user's type to one that is resistant (or immune) to the last move used by the target, randomly.",
    ["Headbutt"] = "Headbutt deals damage and has a 30%% chance of causing the target to flinch.",
    ["Sweet Kiss"] = "Sweet Kiss causes the target to become confused.",
    ["Giga Impact"] = "Giga Impact deals damage but the user can't attack on the next turn.",
    ["Air Slash"] = "Air Slash deals damage and has a 30%% chance of causing the target to flinch.",
    ["Metronome"] = "User performs any move in the game at random.",
    ["Wing Attack"] = "Wing Attack inflicts damage and has no secondary effect.",
    ["Ice Punch"] = "Ice Punch does damage and has a 10%% chance of freezing the target.",
    ["Thunder Fang"] = "Thunder Fang deals damage and has a 10%% chance of paralyzing the target, plus a 10%% chance of causing the target to flinch.",
    ["Crush Claw"] = "Crush Claw deals damage and has a 50%% chance of lowering the target's Defense by one stage.",
    ["Iron Tail"] = "Iron Tail inflicts damage and has a 10%% chance of lowering the target's Defense stat by one stage.",
    ["Signal Beam"] = "Signal Beam deals damage and has a 10%% chance of confusing the target.",
    ["Defense Curl"] = "Defense Curl raises the user's Defense by two stages.",
    ["Sketch"] = "Sketch allows the user to copy the opponent's last move permanently, therefore replacing Sketch.",
    ["Barrier"] = "Barrier raises the user's Defense by two stages.",
    ["Slam"] = "Slam inflicts damage and has no secondary effect.",
    ["Hi Jump Kick"] = "Hi Jump kick deals damage and has no secondary effect.",
    ["Pursuit"] = "Pursuit deals damage and has no secondary effect.",
    ["Bullet Seed"] = "Bullet Seed does damage, hitting 2-5 times per use.",
    ["Sludge Bomb"] = "Sludge Bomb inflicts damage and has a 30%% chance of poisoning the target.",
    ["Dragon Pulse"] = "Dragon Pulse deals damage and has no secondary effect.",
    ["Aqua Ring"] = "The user surrounds itself with a veil of water, allowing it to restore 1/16 of its max HP at the end of every turn during 16 turns.",
    ["Magical Leaf"] = "Magical Leaf deals damage and ignores changes to the Accuracy and Evasion stats.",
    ["Scary Face"] = "Scary Face lowers the target's Speed by two stages.",
    ["Aerial Ace"] = "Aerial Ace deals damage and ignores changes to the Accuracy and Evasion stats.",
    ["Sludge Wave"] = "Sludge Wave inflicts damage and has a 10%% chance of poisoning the target.",
    ["Night Shade"] = "Night Shade deals damage and has no secondary effect.",
    ["Nightmare"] = "The sleeping opponent loses HP during 5 turns.",
    ["Aqua Tail"] = "Aqua Tail deals damage and has no secondary effect.",
    ["Bounce"] = "Bounce deals damage and has no secondary effect.",
    ["Comet Punch"] = "Comet Punch hits 2-5 times per turn used",
    ["Glare"] = "Glare paralyzes the target.",
    ["Curse"] = "Curse is a unique move that works differently for Ghost-type Pokemon than other Pokemon. Ghost-type Pokemon use 50%% of their current HP to place a curse on the target. The cursed Pokemon loses hp during 5 turns. For all other Pokemon, Curse raises the user's Attack and Defense by one stage each and lowers Speed by one stage.",
    ["Sucker Punch"] = "Sucker Punch deals damage and has no secondary effect.",
    ["Poison Fang"] = "Poison Fang inflicts damage and has a 30%% chance of badly poisoning the target.",
    ["Spit Up"] = "Spit Up deals varying damage depending on how many times the user used Stockpile. The base power is 100, 200 or 300 if the user stockpiled one, two or three times respectively.",
    ["Spite"] = "The user drain 100-200 energy from the target.",
    ["Splash"] = "Splash deals damage and has no secondary effect.",
    ["Spore"] = "Spore puts the target to sleep.",
    ["Stockpile"] = "Raises the user's Defense and Special Defense by one stage and charges up power for use with companion moves Spit Up or Swallow.",
    ["Dark Pulse"] = "Dark Pulse deals damage and has a 20%% chance of causing the target to flinch.",
    ["Hydro Pump"] = "Hydro Pump inflicts damage and has no secondary effect.",
    ["Shadow Punch"] = "Shadow Punch inflicts damage and is unaffected by modifications to the Accuracy stat and Evasion stat.",
    ["Poison Jab"] = "Poison Jab inflicts damage and has a 30%% chance of poisoning the target.",
    ["Take Down"] = "Take Down deals damage and has no secondary effect.",
    ["Low Kick"] = "Low Kick deals damage and has no secondary effect.",
    ["Wake-Up Slap"] = "Wake-Up Slap deals damage and will have double the power when the target is sleeping. It will also wake the target up.",
    ["Sand-Attack"] = "Sand-Attack lowers the target's Accuracy by one stage.",
    ["Aromatherapy"] = "Aromatherapy cures the user and friend's of sleep, poison, paralysis, freeze and burn.",
    ["Synthesis"] = "Synthesis restores the user's current HP based on the weather conditions. Under normal conditions Synthesis will restore 1/2 of the user's total HP.",
    ["Magnet Bomb"] = "Magnet Bomb deals damage and ignores changes to the Accuracy and Evasion stats.",
    ["Sky Attack"] = "Nothing will happen on the first turn. On the second turn, Sky Attack deals damage and has a 30%% chance of causing the target to flinch.",
    ["Tickle"] = "Tickle reduces the target's Attack and Defense stat by one stat level each.",
    ["Zen Headbutt"] = "Zen Headbutt deals damage and has a 20%% chance of causing the target to flinch.",
    ["Shadow Sneak"] = "Shadow Sneak deals damage and has no secondary effect.",
    ["Ice Shard"] = "Ice Shard deals damage and has no secondary effect.",
    ["Razor Wind"] = "The user of Razor Wind will 'whip up a whirlwind' on the first turn. On the second turn, Razor Wind deals damage and has an increased critical hit ratio.",
    ["Mirror Coat"] = "Any move is reflected back to the attacker.",
    ["Energy Ball"] = "Energy Ball deals damage and has a 10%% chance of lowering the target's Special Defense by one stage.",
    ["Avalanche"] = "Avalanche deals damage and has no secondary effect.",]]
}

MOVES_DESCRIPTIONS["Protect"] = "Protect raises the user's Defense by two stages."
MOVES_DESCRIPTIONS["Present"] = "Present has two different effects. Present can either deal damage against the target or heal the target."
MOVES_DESCRIPTIONS["Cross Chop"] = "Cross Chop deals damage and has an increased critical hit ratio."
MOVES_DESCRIPTIONS["Fire Fang"] = "Fire Fang deals damage and has a 10%% chance of burning the target, plus a 10%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Skull Bash"] = "Increases Defense on first turn, attacks on second turn."
MOVES_DESCRIPTIONS["Tickle"] = "Tickle reduces the target's Attack and Defense stat by one stat level each."
MOVES_DESCRIPTIONS["String Shot"] = "String Shot lowers the target's Speed by one stage."
MOVES_DESCRIPTIONS["Leaf Blade"] = "Leaf Blade deals damage and has an increased critical hit ratio."
MOVES_DESCRIPTIONS["Quiver Dance"] = "Quiver Dance raises the user's Special Attack, Special Defense and Speed by one stage each."
MOVES_DESCRIPTIONS["Vice Grip"] = "Vice Grip inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Weather Ball"] = "This attack move varies in power and type depending on the weather."
MOVES_DESCRIPTIONS["Hypnosis"] = "Hypnosis puts the target to sleep."
MOVES_DESCRIPTIONS["Aeroblast"] = "A vortex of air is shot at the target to inflict damage. Critical hits land more easily."
MOVES_DESCRIPTIONS["Thrash"] = "The user attacks for 2-3 turns and then becomes confused."
MOVES_DESCRIPTIONS["Rain Dance"] = "Raind Dance raises the user's Attack and Defense by one stage."
MOVES_DESCRIPTIONS["Transform"] = "User takes on the form and attacks of the opponent."
MOVES_DESCRIPTIONS["Air Cutter"] = "Air Cutter deals damage and has an increased critical hit ratio."
MOVES_DESCRIPTIONS["Iron Head"] = "Iron Head inflicts damage and has a 30%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Bone Club"] = "Bone Club deals damage and has a 10%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Psywave"] = "Psywave inflicts a random amount of HP damage, varying by user's level."
MOVES_DESCRIPTIONS["Moonblast"] = "Borrowing the power of the moon, the user attacks the target. This may also lower the target's Sp. Atk stat."
MOVES_DESCRIPTIONS["Sandstorm"] = "A five-turn sandstorm is summoned to hurt all combatants except the Rock, Ground, and Steel types. It raises the Sp. Def stat of Rock types."
MOVES_DESCRIPTIONS["Miracle Eye"] = "Enables a Dark-type target to be hit by Psychic-type attacks. This also enables an evasive target to be hit."
MOVES_DESCRIPTIONS["Hex"] = "Hex inflicts damage, but if the target has a status ailment (i.e. is burned, poisoned, paralyzed, asleep or frozen) it will double in power."
MOVES_DESCRIPTIONS["Heavy Slam"] = "Heavy Slam does damage and has no secondary effect."
MOVES_DESCRIPTIONS["Aqua Jet"] = "The user lunges at the target at a speed that makes it almost invisible."
MOVES_DESCRIPTIONS["Camouflage"] = "The user's type is changed depending on its environment, such as at water's edge, in grass, or in a cave."
MOVES_DESCRIPTIONS["Waterfall"] = "Waterfall does damage and has a 20%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Acid"] = "Acid deals damage and has a 10%% chance of lowering the target's Special Defense by one stage."
MOVES_DESCRIPTIONS["Crabhammer"] = "Crabhammer deals damage and has an increased critical hit ratio."
MOVES_DESCRIPTIONS["Metal Sound"] = "Metal Sound lowers the target's Special Defense by two stages."
MOVES_DESCRIPTIONS["Toxic Spikes"] = "Toxic Spikes deals damage and inflicts Poison, if the target already is Poisoned then inflicits Badly Poison."
MOVES_DESCRIPTIONS["Venom Drench"] = "Opposing Pokemon are drenched in an odd poisonous liquid. This lowers the Attack, Sp. Atk, and Speed stats of a poisoned target."
MOVES_DESCRIPTIONS["Dream Eater"] = "Dream Eater deals damage only on sleeping foes and the user will recover 50%% of the HP drained."
MOVES_DESCRIPTIONS["Crunch"] = "Crunch deals damage and has a 20%% chance of lowering the target's Defense by one stage."
MOVES_DESCRIPTIONS["Shadow Ball"] = "Shadow Ball deals damage and has a 20%% chance of lowering the target's Special Defense by one stage."
MOVES_DESCRIPTIONS["Egg Bomb"] = "Egg Bomb inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Substitute"] = "Creates a replacement who will take all the damage. During this the user can't use any move."
MOVES_DESCRIPTIONS["Simple Beam"] = "The user's mysterious psychic wave changes the target's Ability to Simple."
MOVES_DESCRIPTIONS["Heal Bell"] = "The user makes a soothing bell chime to heal the status conditions of all the party Pokemon."
MOVES_DESCRIPTIONS["Payback"] = "Any move is reflected back to the attacker."
MOVES_DESCRIPTIONS["Avalanche"] = "Avalanche deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Octazooka"] = "The user attacks by spraying ink at the target's face or eyes. This may also lower the target's accuracy."
MOVES_DESCRIPTIONS["Future Sight"] = "Future Sight deals damage, but does not hit until two turns after the move is selected."
MOVES_DESCRIPTIONS["Fell Stinger"] = "When the user knocks out a target with this move, the user's Attack stat rises drastically."
MOVES_DESCRIPTIONS["Cross Poison"] = "Cross Poison deals damage and has a 10%% chance of poisoning the target. It also has an increased critical hit ratio."
MOVES_DESCRIPTIONS["Dragon Breath"] = "The user exhales a mighty gust that inflicts damage. This may also leave the target with paralysis."
MOVES_DESCRIPTIONS["Ancient Power"] = "Ancient Power inflicts damage and has a 10%% chance of raising all of the user's stats by one stage."
MOVES_DESCRIPTIONS["Leaf Storm"] = "Leaf Storm deals damage but lowers the user's Special Attack by two stages after attacking."
MOVES_DESCRIPTIONS["Disable"] = "Disable causes the previous move the target used to be disabled for 100 seconds. If the target has not used any move, then will be random."
MOVES_DESCRIPTIONS["Hyper Fang"] = "Hyper Fang deals damage and has a 10%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Bonemerang"] = "Bonemerang inflicts damage, hitting the target 2 times per use."
MOVES_DESCRIPTIONS["Lick"] = "Lick deals damage and has a 30%% chance of paralyzing the target."
MOVES_DESCRIPTIONS["Vital Throw"] = "Vital Throw deals damage and ignores changes to the Accuracy and Evasion stats."
MOVES_DESCRIPTIONS["Psyshock"] = "The user materializes an odd psychic wave to attack the target. This attack does physical damage."
MOVES_DESCRIPTIONS["Blaze Kick"] = "The user launches a kick that lands a critical hit more easily. This may also leave the target with a burn."
MOVES_DESCRIPTIONS["Swift"] = "Swift deals damage and ignores changes to the Accuracy and Evasion stats."
MOVES_DESCRIPTIONS["Sonic Boom"] = "Sonic Boom deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Flower Shield"] = "The user raises the Defense stat of all Grass-type Pokemon in battle with a mysterious power."
MOVES_DESCRIPTIONS["Rock Tomb"] = "Rock Tomb does damage and lowers the opponent's speed one stage."
MOVES_DESCRIPTIONS["Supersonic"] = "Supersonic causes the target to become confused."
MOVES_DESCRIPTIONS["Psychic Fangs"] = "The user bites the target with its psychic capabilities. This can also destroy Light Screen and Reflect."
MOVES_DESCRIPTIONS["Ingrain"] = "The user lays roots that restore its HP on every turn."
MOVES_DESCRIPTIONS["Freeze-Dry"] = "The user rapidly cools the target. This may also leave the target frozen. This move is super effective on Water types."
MOVES_DESCRIPTIONS["Covet"] = "The user endearingly approaches the target, then steals the target's held item."
MOVES_DESCRIPTIONS["Rapid Spin"] = "Rapid Spin deals a small amount of damage and removes the effects of several 'trap' moves."
MOVES_DESCRIPTIONS["Stored Power"] = "Stored Power deals variable damage depending on the stat modifications of the user. When the user has no stat modifications, Stored Power's base power is 20. Its power increases by 20 for each stat boost the user has."
MOVES_DESCRIPTIONS["Energy Ball"] = "Energy Ball deals damage and has a 10%% chance of lowering the target's Special Defense by one stage."
MOVES_DESCRIPTIONS["Eerie Impulse"] = "The user's body generates an eerie impulse. Exposing the target to it harshly lowers the target's Sp. Atk stat."
MOVES_DESCRIPTIONS["Foresight"] = "Foresight removes the Ghost type's immunity to Fighting-type and Normal-type moves for any moves used against the target."
MOVES_DESCRIPTIONS["Rest"] = "User sleeps for 5 seconds, but user is fully healed."
MOVES_DESCRIPTIONS["Gust"] = "Gust deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Bullet Punch"] = "Bullet Punch deals damage."
MOVES_DESCRIPTIONS["Charge"] = "If the user's next move is Electric-type, its base power will be doubled. Charge also raises the user's Special Defense by one stat level."
MOVES_DESCRIPTIONS["Luster Purge"] = "Luster Purge inflicts damage and has a 50%% chance of lowering the target's Special Defense."
MOVES_DESCRIPTIONS["Confuse Ray"] = "Confuse Ray causes the target to become confused."
MOVES_DESCRIPTIONS["Blizzard"] = "Blizzard deals damage and has a 10%% chance of freezing the opponent."
MOVES_DESCRIPTIONS["Mist Ball"] = "Mist Ball inflicts damage and has a 50%% chance of lowering the target's Special Attack."
MOVES_DESCRIPTIONS["Eruption"] = "Eruption does damage proportionately based on the user's HP. This move's base power reduces as the user's HP reduces and is calculated by the formula: Power = 150 x current HP / maximum HP. Hence, at maximum HP (100%% HP), the move's base power would be 150."
MOVES_DESCRIPTIONS["Echoed Voice"] = "Echoed Voice deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Hyper Voice"] = "Hyper Voice inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Ally Switch"] = "Change position with target."
MOVES_DESCRIPTIONS["Fire Blast"] = "Fire Blast inflicts damage and has a 10%% chance of burning the target."
MOVES_DESCRIPTIONS["Hidden Power"] = "A unique attack that varies in type depending on the Pokemon using it."
MOVES_DESCRIPTIONS["Toxic"] = "Toxic causes the target to be badly poisoned."
MOVES_DESCRIPTIONS["Flail"] = "Flail inflicts damage. Its power is higher when the user's HP is lower."
MOVES_DESCRIPTIONS["Acrobatics"] = "Acrobatics deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Poison Gas"] = "Poison Gas poisons the target. It will fail if the target is Poison or Steel-type."
MOVES_DESCRIPTIONS["Vine Whip"] = "Vine Whip inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Chip Away"] = "Looking for an opening, the user strikes consistently. The target's stat changes don't affect this attack's damage."
MOVES_DESCRIPTIONS["Ice Beam"] = "Ice Beam inflicts damage and has a 10%% chance of freezing the target."
MOVES_DESCRIPTIONS["Magnet Bomb"] = "Magnet Bomb deals damage and ignores changes to the Accuracy and Evasion stats."
MOVES_DESCRIPTIONS["Grassy Terrain"] = "The user turns the ground to grass for five turns. This restores the HP of Pokemon on the ground a little every turn."
MOVES_DESCRIPTIONS["Amnesia"] = "Amnesia raises the user's Special Defense by two stages."
MOVES_DESCRIPTIONS["Acid Spray"] = "Acid Spray inflicts damage and lowers the target's Special Defense by two stages."
MOVES_DESCRIPTIONS["Giga Drain"] = "Giga Drain deals damage and the user will recover 50%% of the HP drained."
MOVES_DESCRIPTIONS["Drill Peck"] = "Drill Peck inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Double Hit"] = "Double Hit hits twice in one turn."
MOVES_DESCRIPTIONS["Sludge Bomb"] = "Sludge Bomb inflicts damage and has a 30%% chance of poisoning the target."
MOVES_DESCRIPTIONS["Brine"] = "Brine inflicts damage, and its power doubles to 130 when the target is at or below 50%% health."
MOVES_DESCRIPTIONS["Mud Bomb"] = "Mud Bomb deals damage and has a 30%% chance of lowering the target's Accuracy by one stage."
MOVES_DESCRIPTIONS["Fake Out"] = "Fake Out inflicts damage and makes the target flinch."
MOVES_DESCRIPTIONS["Detect"] = "Enables the user to evade all attacks. Its chance of failing rises if it is used in succession."
MOVES_DESCRIPTIONS["Electro Ball"] = "Electro Ball deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Electroweb"] = "Electroweb inflicts damage and then lowers the target's Speed stat by one stage."
MOVES_DESCRIPTIONS["Encore"] = "The user compels the target to keep using the move it encored for three turns."
MOVES_DESCRIPTIONS["Sand Tomb"] = "Sand Tomb inflicts damage, hiting the target 5 times per use and lower the Speed of the target by two stages."
MOVES_DESCRIPTIONS["Heal Pulse"] = "Heal Pulse recover party members HP."
MOVES_DESCRIPTIONS["Smoke Screen"] = "Smoke Screen lowers the target's Accuracy by one stage."
MOVES_DESCRIPTIONS["Hone Claws"] = "Hone Claws raises the user's Attack by one stage."
MOVES_DESCRIPTIONS["Power Whip"] = "Power Whip inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Razor Leaf"] = "Razor Leaf deals damage and has an increased critical hit ratio."
MOVES_DESCRIPTIONS["Explosion"] = "Explosion deals high damage, but causes the user to faint."
MOVES_DESCRIPTIONS["Mega Punch"] = "Mega Punch deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Boomburst"] = "Boomburst does damage and has no secondary effect. Pokemon with the Ability Soundproof are not affected by this move."
MOVES_DESCRIPTIONS["Confusion"] = "Confusion deals damage and has a 10%% chance of confusing the target."
MOVES_DESCRIPTIONS["Synchronoise"] = "Using an odd shock wave, the user inflicts damage on any Pokemon of the same type in the area around it."
MOVES_DESCRIPTIONS["Growl"] = "The user growls in a cute way, making the foe lower its ATTACK. stat."
MOVES_DESCRIPTIONS["Venoshock"] = "Venoshock inflicts damage and its power will double to 130 when the target is poisoned."
MOVES_DESCRIPTIONS["Draining Kiss"] = "The user steals the target's HP with a kiss. The user's HP is restored by over half of the damage taken by the target."
MOVES_DESCRIPTIONS["Endure"] = "The user endures any attack with at least 1 HP. Its chance of failing rises if it is used in succession."
MOVES_DESCRIPTIONS["Spiky Shield"] = "Spiky Shield protects the user from all effects of moves that target the user during the turn it is used, including damage."
MOVES_DESCRIPTIONS["Dark Pulse"] = "Dark Pulse deals damage and has a 20%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Acid Armor"] = "Acid Armor raises the user's Defense by two stages."
MOVES_DESCRIPTIONS["Horn Drill"] = "Horn Drill deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Flare Blitz"] = "Flare Blitz will thaw out the user if it is frozen, and then inflict damage on the target."
MOVES_DESCRIPTIONS["Aurora Beam"] = "Aurora Beam deals damage and has a 10%% chance of lowering the target's Attack by one stage."
MOVES_DESCRIPTIONS["Selfdestruct"] = "Resembling a weaker version of Explosion, Selfdestruct inflicts damage, and causes the user to faint. "
MOVES_DESCRIPTIONS["Wood Hammer"] = "Wood Hammer inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Scald"] = "The user shoots boiling hot water at its target. This may also leave the target with a burn."
MOVES_DESCRIPTIONS["Belch"] = "The user lets out a damaging belch at the target."
MOVES_DESCRIPTIONS["Sleep Powder"] = "Sleep Powder puts the target to sleep."
MOVES_DESCRIPTIONS["Sunny Day"] = "Sunny Day increase's user ATTACK and DEFENSE stats."
MOVES_DESCRIPTIONS["Seismic Toss"] = "Seismic Toss deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Solar Beam"] = "Solar Beam deals damage but the user can't attack on the next turn."
MOVES_DESCRIPTIONS["Flame Wheel"] = "Flame Wheel will thaw out the user if it is frozen, and then inflict damage on the target. Flame Wheel also has a 10%% chance of burning the target."
MOVES_DESCRIPTIONS["Heat Wave"] = "The user exhales a heated breath to attack. It may also inflict a burn."
MOVES_DESCRIPTIONS["Smog"] = "Smog inflicts damage and has a 40%% chance of poisoning the target."
MOVES_DESCRIPTIONS["Astonish"] = "The user attacks the target while shouting in a startling fashion. This may also make the target flinch."
MOVES_DESCRIPTIONS["Brick Break"] = "Brick Break deals damage, but removes the effects of Reflect before attacking."
MOVES_DESCRIPTIONS["Coil"] = "Coil raises the user's Attack, Defense by by one stage each and clear Accuracy ."
MOVES_DESCRIPTIONS["Bide"] = "The user of Bide 'stores energy' for 2 turns. At the end of the second turn the Pokemon 'unleashes energy', dealing twice the HP damage it received. "
MOVES_DESCRIPTIONS["Dragon Dance"] = "Dragon Dance raises the user's Attack and Speed by one stage each."
MOVES_DESCRIPTIONS["Yawn"] = "In the turn that Yawn is used, the only effect will be the user yawning at the target. At the end of the next turn, the target (if still active) will fall asleep unless it gets affected by a major status condition in the meantime, a status-protecting move is used (like Safeguard or Uproar), or the battle ends."
MOVES_DESCRIPTIONS["Metal Burst"] = "Metal Burst returns 1.5 times the damage dealt by the foe's last attack."
MOVES_DESCRIPTIONS["Lunge"] = "The user makes a lunge at the target, attacking with full force. This also lowers the target's Attack stat."
MOVES_DESCRIPTIONS["Mach Punch"] = "The user throws a punch at blinding speed. This move always goes first."
MOVES_DESCRIPTIONS["Cosmic Power"] = "Cosmic Power boosts the Defense and Special Defense of the user by one stage each."
MOVES_DESCRIPTIONS["Copycat"] = "The user mimics the move used immediately before it. The move fails if no other move has been used yet."
MOVES_DESCRIPTIONS["Seed Bomb"] = "The user slams a barrage of hard-shelled seeds down on the target from above."
MOVES_DESCRIPTIONS["Sky Uppercut"] = "The user attacks the target with an uppercut thrown skyward with force."
MOVES_DESCRIPTIONS["Heal Block"] = "Heal Block restricts the targets from healing in certain ways for five turns."
MOVES_DESCRIPTIONS["Double Kick"] = "Double Kick inflicts damage, hitting the target 2 times per use."
MOVES_DESCRIPTIONS["Fissure"] = "Fissure deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Spark"] = "Spark inflicts damage and has a 30%% chance of paralyzing the target."
MOVES_DESCRIPTIONS["Giga Impact"] = "Giga Impact deals damage but the user can't attack on the next turn."
MOVES_DESCRIPTIONS["Aerial Ace"] = "Aerial Ace deals damage and ignores changes to the Accuracy and Evasion stats."
MOVES_DESCRIPTIONS["Roost"] = "User recovers half of its max HP. Flying types temporarily lose Ground type immunity."
MOVES_DESCRIPTIONS["Absorb"] = "Absorb deals damage and the user will recover 50%% of the HP drained."
MOVES_DESCRIPTIONS["Arm Thrust"] = "The user lets loose a flurry of open-palmed arm thrusts that hit two to five times in a row."
MOVES_DESCRIPTIONS["Mind Reader"] = "The user predicts the foe's action to ensure its next attack hits."
MOVES_DESCRIPTIONS["Power-Up Punch"] = "Power-Up Punch does damage and raises the user's Attack by one stage."
MOVES_DESCRIPTIONS["Air Slash"] = "Air Slash deals damage and has a 30%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Grass Whistle"] = "Grass Whistle puts the target to sleep."
MOVES_DESCRIPTIONS["Steel Wing"] = "Steel Wing inflicts damage and has a 10%% chance of raising the user's Defense."
MOVES_DESCRIPTIONS["Lovely Kiss"] = "Lovely Kiss causes the target to fall asleep."
MOVES_DESCRIPTIONS["Dig"] = "Dig does damage and has no secondary effect."
MOVES_DESCRIPTIONS["Bullet Seed"] = "Bullet Seed does damage, hitting 2-5 times per use."
MOVES_DESCRIPTIONS["Water Sport"] = "Water Sport increases user ATTACK and DEFENSE stats."
MOVES_DESCRIPTIONS["Night Slash"] = "Night Slash deals damage and has an increased critical hit ratio."
MOVES_DESCRIPTIONS["Gastro Acid"] = "The user hurls up its stomach acids on the target. The fluid eliminates the effect of the target's Ability."
MOVES_DESCRIPTIONS["Faint Attack"] = "Faint Attack deals damage and ignores changes to the Accuracy and Evasion stats."
MOVES_DESCRIPTIONS["Meowth Super Rocket"] = ""
MOVES_DESCRIPTIONS["Gyro Ball"] = "Gyro Ball deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Will-O-Wisp"] = "Will-O-Wisp inflicts a burn on the target. It has no effect on Fire-type Pokemon."
MOVES_DESCRIPTIONS["Disarming Voice"] = "Letting out a charming cry, the user does emotional damage to opposing Pokemon. This attack never misses."
MOVES_DESCRIPTIONS["Bite"] = "Bite deals damage and has a 30%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Charge Beam"] = "Charge Beam deals damage and has a 70%% chance of raising the user's Special Attack by one stage."
MOVES_DESCRIPTIONS["U-turn"] = "U-turn does damage and has no secondary effect."
MOVES_DESCRIPTIONS["Silver Wind"] = "Silver Wind deals damage and has a 10%% chance of raising the user's Attack, Defense, Special Attack, Special Defense and Speed by one stage each."
MOVES_DESCRIPTIONS["Dazzling Gleam"] = "The user damages opposing Pokemon by emitting a powerful flash."
MOVES_DESCRIPTIONS["Whirlpool"] = "The user traps the target in a violent swirling whirlpool for four to five turns."
MOVES_DESCRIPTIONS["Meditate"] = "Meditate raises the user's Attack by one stage."
MOVES_DESCRIPTIONS["Defense Curl"] = "Defense Curl raises the user's Defense by two stages."
MOVES_DESCRIPTIONS["Aura Sphere"] = "The user lets loose a blast of aura power from deep within its body at the target. This attack never misses."
MOVES_DESCRIPTIONS["Bug Bite"] = "Bug Bite deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Brave Bird"] = "The user tucks in its wings and charges from a low altitude. This also damages the user quite a lot."
MOVES_DESCRIPTIONS["Horn Attack"] = "Horn Attack deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Head Smash"] = "Head Smash does damage and has no secondary effect."
MOVES_DESCRIPTIONS["Moonlight"] = "Moonlight restores the user's current HP based on the weather conditions and time of day. Normal conditions will restore ½ of the total HP."
MOVES_DESCRIPTIONS["Mega Kick"] = "Mega Kick deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Thunder Wave"] = "Thunder Wave paralyzes the target. Thunder Wave will not work against Ground types."
MOVES_DESCRIPTIONS["Stealth Rock"] = "Stealth Rock deals damage and lower the Speed of the target by two stages."
MOVES_DESCRIPTIONS["Bulldoze"] = "The user strikes everything around it by stomping down on the ground. This lowers the Speed stat of those hit."
MOVES_DESCRIPTIONS["Thunder"] = "Thunder deals damage and has a 30%% chance of paralyzing the target."
MOVES_DESCRIPTIONS["Bulk Up"] = "The user bulks up its body to boost both its ATTACK and DEFENSE stats."
MOVES_DESCRIPTIONS["Circle Throw"] = "Circle Throw does damage and has no secondary effect."
MOVES_DESCRIPTIONS["Powder Snow"] = "Powder Snow inflicts damage and has a 10%% chance of freezing the target."
MOVES_DESCRIPTIONS["Karate Chop"] = "Karate Chop deals damage and has an increased critical hit ratio."
MOVES_DESCRIPTIONS["Uproar"] = "The user attacks in an uproar for three turns. During that time, no Pokemon can fall asleep."
MOVES_DESCRIPTIONS["Frenzy Plant"] = "Frenzy Plant deals damage but the user can't attack on the next turn."
MOVES_DESCRIPTIONS["Pluck"] = "The user pecks the target. If the target is holding a Berry, the user eats it and gains its effect."
MOVES_DESCRIPTIONS["Submission"] = "Submission deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Rock Slide"] = "Rock Slide deals damage and has a 30%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Flatter"] = "Flattery is used to confuse the target. However, this also raises the target's Sp. Atk stat."
MOVES_DESCRIPTIONS["Curse"] = "Curse is a unique move that works differently for Ghost-type Pokemon than other Pokemon. Ghost-type Pokemon use 50%% of their current HP to place a curse on the target. The cursed Pokemon loses hp during 5 turns. For all other Pokemon, Curse raises the user's Attack and Defense by one stage each and lowers Speed by one stage."
MOVES_DESCRIPTIONS["Hammer Arm"] = "Hammer Arm does damage, then lowers the user's Speed by one level."
MOVES_DESCRIPTIONS["Superpower"] = "Superpower deals damage but lowers the user's Attack and Defense by one stage each after attacking."
MOVES_DESCRIPTIONS["Metronome"] = "User performs any move in the game at random."
MOVES_DESCRIPTIONS["Origin Pulse"] = "Origin Pulse deals damage to all adjacent opponents. Its power is boosted by 50%% when used by a Pokemon with the Ability Mega Launcher."
MOVES_DESCRIPTIONS["Headbutt"] = "Headbutt deals damage and has a 30%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Iron Tail"] = "Iron Tail inflicts damage and has a 10%% chance of lowering the target's Defense stat by one stage."
MOVES_DESCRIPTIONS["Tackle"] = "Tackle is one of the most common and basic moves a Pokemon learns. It deals damage with no additional effects."
MOVES_DESCRIPTIONS["Extreme Speed"] = "Extreme Speed deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Flamethrower"] = "Flamethrower deals damage and has a 10%% chance of burning the target."
MOVES_DESCRIPTIONS["Inferno"] = "Inferno deals damage and will always burn the target if it hits."
MOVES_DESCRIPTIONS["Haze"] = "Resets all stat changes."
MOVES_DESCRIPTIONS["Captivate"] = "Captivate lowers the Special Attack of the target by two stages, if they are of the opposite gender to the user."
MOVES_DESCRIPTIONS["Discharge"] = "Discharge deals damage and has a 30%% chance of paralyzing the target(s)."
MOVES_DESCRIPTIONS["Bounce"] = "Bounce deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Role Play"] = "The user mimics the target completely, copying the target's natural Ability."
MOVES_DESCRIPTIONS["Tri Attack"] = "Tri Attack deals damage and has a 20%% chance of paralyzing, burning or freezing the target - i.e. a 6.67%% chance of each status condition."
MOVES_DESCRIPTIONS["Bubblebeam"] = "Bubblebeam deals damage and has a 10%% chance of lowering the target's Speed by one stage."
MOVES_DESCRIPTIONS["Zap Cannon"] = "Zap Cannon deals damage and paralyzes the target."
MOVES_DESCRIPTIONS["Screech"] = "Screech lowers the target's Defense by two stages."
MOVES_DESCRIPTIONS["Hail"] = "The user summons a hailstorm lasting five turns. It damages all Pokemon except the Ice type."
MOVES_DESCRIPTIONS["Mimic"] = "Mimic copies the target's last move. If there isn't a last move, copy random."
MOVES_DESCRIPTIONS["Icicle Crash"] = "The user attacks by harshly dropping large icicles onto the target. This may also make the target flinch."
MOVES_DESCRIPTIONS["Fairy Wind"] = "The user stirs up a fairy wind and strikes the target with it."
MOVES_DESCRIPTIONS["Leech Seed"] = "Leech Seed plants a seed on the target. At the end of each turn that the target is under the effect of Leech Seed, the target's HP will be drained, and the same amount of HP will be restored to the target's opponent. Leech Seed will not work against Grass-type Pokemon."
MOVES_DESCRIPTIONS["Flash Cannon"] = "Flash Cannon deals damage and has a 10%% chance of lowering the target's Special Defense by one stage."
MOVES_DESCRIPTIONS["Water Gun"] = "Water Gun inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Megahorn"] = "Megahorn deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Petal Dance"] = "The user attacks for 2-3 turns and then becomes confused."
MOVES_DESCRIPTIONS["Sacred Fire"] = "The target is razed with a mystical fire of great intensity. This may also leave the target with a burn."
MOVES_DESCRIPTIONS["Scary Face"] = "Scary Face lowers the target's Speed by two stages."
MOVES_DESCRIPTIONS["Magic Coat"] = "Any move is reflected back to the attacker."
MOVES_DESCRIPTIONS["Sketch"] = "Sketch allows the user to copy the opponent's last move permanently, therefore replacing Sketch."
MOVES_DESCRIPTIONS["Guillotine"] = "Guillotine deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Bubble"] = "Bubble deals damage and has a 10%% chance of lowering the target's Speed by one stage."
MOVES_DESCRIPTIONS["Assurance"] = "Assurance does damage and has no secondary effect."
MOVES_DESCRIPTIONS["Hyper Beam"] = "Hyper Beam deals damage but the user can't attack on the next turn."
MOVES_DESCRIPTIONS["Earthquake"] = "Earthquake deals damage."
MOVES_DESCRIPTIONS["Feather Dance"] = "Feather Dance lowers the target's Attack by two stages."
MOVES_DESCRIPTIONS["Mega Drain"] = "Mega Drain inflicts damage, and 50%% of the damage dealt to the target is restored to the user. The amount of HP recovered is always rounded down."
MOVES_DESCRIPTIONS["Flame Charge"] = "Flame Charge inflicts damage and raises the user's Speed by one level."
MOVES_DESCRIPTIONS["Dizzy Punch"] = "Dizzy Punch deals damage and has a 20%% chance of confusing the target."
MOVES_DESCRIPTIONS["Dragon Claw"] = "Dragon Claw inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Jump Kick"] = "Jump Kick deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Rocket Missile"] = ""
MOVES_DESCRIPTIONS["Crush Claw"] = "Crush Claw deals damage and has a 50%% chance of lowering the target's Defense by one stage."
MOVES_DESCRIPTIONS["Lava Plume"] = "Lava Plume deals damage ans has 30%% of chance to burn the target."
MOVES_DESCRIPTIONS["Destiny Bond"] = "After using this move, if the user faints, the Pokemon that landed the knockout hit also faints. Its chance of failing rises if it is used in succession."
MOVES_DESCRIPTIONS["Bug Buzz"] = "Bug Buzz deals damage and has a 10%% chance of lowering the target's Special Defense by one stage."
MOVES_DESCRIPTIONS["Defog"] = "A strong wind blows away the target's barriers such as Reflect or Light Screen."
MOVES_DESCRIPTIONS["Metal Claw"] = "Metal Claw deals damage and has a 10%% chance of raising the user's Attack by one stage."
MOVES_DESCRIPTIONS["Healing Wish"] = "The user become with 1 HP and all party members recover full HP."
MOVES_DESCRIPTIONS["Misty Terrain"] = "This protects Pokemon on the ground from status conditions."
MOVES_DESCRIPTIONS["Phantom Force"] = "The user vanishes somewhere, then strikes the target on the next turn."
MOVES_DESCRIPTIONS["Refresh"] = "Cures paralysis, poison, and burns."
MOVES_DESCRIPTIONS["Fury Attack"] = "Fury Attack does damage, hitting 2-5 times per use."
MOVES_DESCRIPTIONS["Heart Stamp"] = "The user unleashes a vicious blow after its cute act makes the target less wary. This may also make the target flinch."
MOVES_DESCRIPTIONS["Double Slap"] = "Double Slap inflicts damage and hits between 2-5 times per use."
MOVES_DESCRIPTIONS["Endeavor"] = "Endeavor deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Ember"] = "Ember does damage and has a 10%% chance of burning the target."
MOVES_DESCRIPTIONS["Gunk Shot"] = "Gunk Shot deals damage and has a 30%% chance of poisoning the target."
MOVES_DESCRIPTIONS["Stone Edge"] = "Stone Edge deals damage and has an increased critical hit ratio."
MOVES_DESCRIPTIONS["Psycho Cut"] = "Psycho Cut deals damage and has an increased critical hit ratio."
MOVES_DESCRIPTIONS["Slam"] = "Slam inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Comet Punch"] = "Comet Punch hits 2-5 times per turn used"
MOVES_DESCRIPTIONS["Focus Energy"] = "Increases Critical-Hit ratio by 50%%."
MOVES_DESCRIPTIONS["Glare"] = "Glare paralyzes the target."
MOVES_DESCRIPTIONS["Softboiled"] = "User recovers 50%% of its max HP."
MOVES_DESCRIPTIONS["Agility"] = "Agility raises the user's Speed by two stages."
MOVES_DESCRIPTIONS["Mirror Move"] = "Mirror Move copies the target's last move. If there isn't a last move, copy random."
MOVES_DESCRIPTIONS["Drill Run"] = "Drill Run deals damage and has an increased critical hit ratio."
MOVES_DESCRIPTIONS["Body Slam"] = "Body Slam deals damage and has a 30%% chance of paralyzing the target."
MOVES_DESCRIPTIONS["Icy Wind"] = "Icy Wind deals damage and lowers the target's Speed by one stage."
MOVES_DESCRIPTIONS["Sleep Talk"] = "While it is asleep, the user randomly uses one of the moves it knows."
MOVES_DESCRIPTIONS["Magnitude"] = "Magnitude does not have a set base power. Instead the base power of this move varies on a magnitude scale between four and ten."
MOVES_DESCRIPTIONS["Last Resort"] = "Last Resort does damage and has no secondary effect."
MOVES_DESCRIPTIONS["Stomp"] = "Stomp deals damage and has a 30%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Needle Arm"] = "Needle Arm inflicts damage and has a 30%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Smack Down"] = "The user throws a stone or similar projectile to attack an opponent. A flying Pokemon will fall to the ground when it's hit."
MOVES_DESCRIPTIONS["Smelling Salts"] = "Smelling Salts deals damage. Its base power will double against a paralyzed target, but it will also cure the target of paralysis."
MOVES_DESCRIPTIONS["Thief"] = "The user attacks and steals the target's held item simultaneously. The user can't steal anything if it already holds an item."
MOVES_DESCRIPTIONS["Mist"] = "The user cloaks itself and its allies in a white mist that prevents any of their stats from being lowered."
MOVES_DESCRIPTIONS["Cotton Guard"] = "Cotton Guard raises the user's Defense stat by three stages."
MOVES_DESCRIPTIONS["Mud Shot"] = "Mud Shot deals damage and lowers the target's Speed by one stage."
MOVES_DESCRIPTIONS["Worry Seed"] = "Worry Seed inflicits an Insonia to the target. With this effect, the target Pokemon cannot sleep and wakes up if already asleep."
MOVES_DESCRIPTIONS["Spike Cannon"] = "Spike Cannon inflicts damage, hitting the target 2-5 times per use."
MOVES_DESCRIPTIONS["Low Sweep"] = "The user makes a swift attack on the target's legs, which lowers the target's Speed stat."
MOVES_DESCRIPTIONS["Swords Dance"] = "Swords Dance raises the user's Attack by two stages."
MOVES_DESCRIPTIONS["Fury Cutter"] = "Fury Cutter deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Sheer Cold"] = "The foe is attacked with a blast of absolute-zero cold dealing damage equal to the opponent's 30%% HP. It will fail if the target's level is higher than the user's level. Ice-type Pokemon era immune to Sheer Cold."
MOVES_DESCRIPTIONS["Shell Smash"] = "The user breaks its shell, which lowers Defense and Sp. Def stats but sharply raises its Attack, Sp. Atk, and Speed stats."
MOVES_DESCRIPTIONS["Synthesis"] = "Synthesis restores the user's current HP based on the weather conditions. Under normal conditions Synthesis will restore ½ of the user's total HP."
MOVES_DESCRIPTIONS["Mud-Slap"] = "Mud-Slap deals damage and lowers the target's Accuracy by one stage."
MOVES_DESCRIPTIONS["Psychic"] = "Psychic deals damage and has a 10%% chance of lowering the target's Special Defense by one stage."
MOVES_DESCRIPTIONS["Charm"] = "Charm lowers the Attack stat of the target by two stages."
MOVES_DESCRIPTIONS["Hurricane"] = "Hurricane deals damage and has a 30%% chance of confusing the target."
MOVES_DESCRIPTIONS["Milk Drink"] = "Milk Drink restores up to 50%% of the user's current HP."
MOVES_DESCRIPTIONS["Fire Spin"] = "Fire Spin does damage and lower the target's Speed by two stages."
MOVES_DESCRIPTIONS["Poison Powder"] = "Poison Powder poisons the target."
MOVES_DESCRIPTIONS["X-Scissor"] = "X-Scissor deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Leaf Tornado"] = "Leaf Tornado deals damage and has a 30%% chance of lowering the target's Accuracy by one stage."
MOVES_DESCRIPTIONS["Thunderbolt"] = "Thunderbolt does damage and has a 10%% chance of paralyzing the target."
MOVES_DESCRIPTIONS["Thunder Shock"] = "Thunder Shock inflicts damage and has a 10%% chance of paralyzing the target."
MOVES_DESCRIPTIONS["Rolling Kick"] = "Rolling Kick deals damage and has a 30%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Rage Powder"] = "Rage Powder redirects all single-target opponents to itself."
MOVES_DESCRIPTIONS["Muddy Water"] = "Muddy Water deals damage and has a 30%% chance of lowering the target's Accuracy by one stage."
MOVES_DESCRIPTIONS["Counter"] = "When hit by a Physical Attack, user strikes back with 2x power."
MOVES_DESCRIPTIONS["Clamp"] = "The target is clamped and squeezed by the user's very thick and sturdy shell for four to five turns."
MOVES_DESCRIPTIONS["Power Gem"] = "Power Gem inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Double-Edge"] = "Double-Edge deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Pound"] = "Pound inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Incinerate"] = "Incinerate does damage and has no secondary effect."
MOVES_DESCRIPTIONS["Outrage"] = "User attacks for 2-3 turns and then becomes confused."
MOVES_DESCRIPTIONS["Poison Sting"] = "Poison Sting inflicts damage and has a 30%% chance of poisoning the target."
MOVES_DESCRIPTIONS["Constrict"] = "Constrict deals damage and has a 10%% chance of lowering the target's Speed by one stage."
MOVES_DESCRIPTIONS["Nasty Plot"] = "Nasty Plot raises the user's Special Attack stat by two stages."
MOVES_DESCRIPTIONS["Aromatherapy"] = "Aromatherapy cures the user and friend's of sleep, poison, paralysis, freeze and burn."
MOVES_DESCRIPTIONS["Ominous Wind"] = "Ominous Wind inflicts damage and has a 10%% chance of raising all of the user's stats by one stage."
MOVES_DESCRIPTIONS["Clear Smog"] = "Clear Smog inflicts damage and resets all stat levels of the target to 0."
MOVES_DESCRIPTIONS["Hydro Cannon"] = "Hydro Cannon deals damage but the user can't attack on the next turn."
MOVES_DESCRIPTIONS["Bone Rush"] = "Bone Rush inflicts damage, hitting the target 2-5 times per use."
MOVES_DESCRIPTIONS["Psycho Shift"] = "Psycho Shift transfers any non-volatile status ailment from the user to the target, curing the user in the process. It will not transfer volatile status ailments (confusion, etc.)."
MOVES_DESCRIPTIONS["Frost Breath"] = "The user blows its cold breath on the target. This attack always results in a critical hit."
MOVES_DESCRIPTIONS["Razor Shell"] = "Razor Shell deals damage and has a 50%% chance of lowering the target's Defense by one stage."
MOVES_DESCRIPTIONS["Overheat"] = "An intense attack that also sharply reduces the user's SP. ATK stat."
MOVES_DESCRIPTIONS["Poison Jab"] = "Poison Jab inflicts damage and has a 30%% chance of poisoning the target."
MOVES_DESCRIPTIONS["Triple Kick"] = "Triple Kick deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Meteor Mash"] = "Meteor Mash deals damage and has a 20%% chance of raising the user's Attack by one stage."
MOVES_DESCRIPTIONS["Double Team"] = "Double Team increases the user's speed into maximum, creating illusions."
MOVES_DESCRIPTIONS["Force Palm"] = "Force Palm inflicts damage and has a 30%% chance of paralyzing the target."
MOVES_DESCRIPTIONS["Brutal Swing"] = "Brutal Swing does damage and has no secondary effect."
MOVES_DESCRIPTIONS["Swallow"] = "Swallow recovers a varying amount of HP depending on how many times the user has used Stockpile. It recovers 25%%, 50%% or 100%% of the user's maximum HP if the user stockpiled one, two or three times respectively."
MOVES_DESCRIPTIONS["Stun Spore"] = "Stun Spore paralyzes the target."
MOVES_DESCRIPTIONS["Snore"] = "Snore can only be used whilst the user is sleeping and will fail if the user is not."
MOVES_DESCRIPTIONS["Dragon Tail"] = "Dragon Tail deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Thunder Punch"] = "Thunder Punch does damage and has a 10%% chance of paralyzing the opponent."
MOVES_DESCRIPTIONS["Peck"] = "Peck inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Pin Missile"] = "Pin Missile inflicts damage, hitting the target between 2-5 times per use."
MOVES_DESCRIPTIONS["Safeguard"] = "The user's party is protected from status conditions."
MOVES_DESCRIPTIONS["Rage"] = "Rage inflicts damage, hitting the target 2-5 times per use."
MOVES_DESCRIPTIONS["Harden"] = "Harden raises the user's Defense by one stage."
MOVES_DESCRIPTIONS["Play Rough"] = "The user plays rough with the target and attacks it. This may also lower the target's Attack stat."
MOVES_DESCRIPTIONS["Precipice Blade"] = "Precipice Blade does damage and has no secondary effect."
MOVES_DESCRIPTIONS["Knock Off"] = "The move does more damage if the target has a held item."
MOVES_DESCRIPTIONS["Petal Blizzard"] = "The user stirs up a violent petal blizzard and attacks everything around it."
MOVES_DESCRIPTIONS["Fake Tears"] = "Fake Tears lowers the target's Special Defense stat by two stages."
MOVES_DESCRIPTIONS["Poison Fang"] = "Poison Fang inflicts damage and has a 30%% chance of badly poisoning the target."
MOVES_DESCRIPTIONS["Calm Mind"] = "Calm Mind raises the user's Special Attack and Special Defense by one stage each."
MOVES_DESCRIPTIONS["Wish"] = "The turn Wish is used, the user will make a wish. At the end of the next turn, the Pokemon will be healed by half its own maximum HP."
MOVES_DESCRIPTIONS["Quick Attack"] = "Quick Attack deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Twineedle"] = "Twineedle deals damage and will strike twice (with 25 base power each time). It has a 20%% chance of poisoning the target, except for Poison or Steel types which cannot be poisoned."
MOVES_DESCRIPTIONS["Dive"] = "Dive does damage and has no secondary effect."
MOVES_DESCRIPTIONS["Poison Tail"] = "Poison Tail deals damage and has an increased critical hit ratio. It has a 10%% chance of poisoning the target."
MOVES_DESCRIPTIONS["Ice Fang"] = "Ice Fang deals damage and has a 10%% chance of freezing the target, plus a 10%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Focus Punch"] = "Focus Punch charge during 5 turns and then deals damage."
MOVES_DESCRIPTIONS["Icicle Spear"] = "The user launches sharp icicles at the target two to five times in a row."
MOVES_DESCRIPTIONS["Fire Punch"] = "Fire Punch does damage and has a 10%% chance of burning the target."
MOVES_DESCRIPTIONS["Punishment"] = "Punishment deals varying damage based on the opponent's stat increases. It starts at base power 60 and increases by 20 for every net stat boost of the opponent."
MOVES_DESCRIPTIONS["Dragon Rush"] = "The user tackles the target while exhibiting overwhelming menace. This may also make the target flinch."
MOVES_DESCRIPTIONS["Psystrike"] = "The user materializes an odd psychic wave to attack the target. This attack does physical damage."
MOVES_DESCRIPTIONS["Memento"] = "Memento causes the user to faint and in return lowers the Attack and Special Attack stat of the target by two stages each."
MOVES_DESCRIPTIONS["Pursuit"] = "Pursuit deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Dragon Rage"] = "Dragon Rage deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Shock Wave"] = "Shock Wave inflicts damage and is unaffected by modifications to the Accuracy stat and Evasion stat."
MOVES_DESCRIPTIONS["Psybeam"] = "Psybeam deals damage and has a 10%% chance of confusing the target."
MOVES_DESCRIPTIONS["Surf"] = "Surf inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Shadow Punch"] = "Shadow Punch inflicts damage and is unaffected by modifications to the Accuracy stat and Evasion stat."
MOVES_DESCRIPTIONS["Reflect"] = "Any move is reflected back to the attacker."
MOVES_DESCRIPTIONS["Sing"] = "Sing puts the target to sleep."
MOVES_DESCRIPTIONS["Sludge Wave"] = "Sludge Wave inflicts damage and has a 10%% chance of poisoning the target."
MOVES_DESCRIPTIONS["Twister"] = "Twister deals damage and has a 30%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Extrasensory"] = "Extrasensory inflicts damage and has a 10%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Zen Headbutt"] = "Zen Headbutt deals damage and has a 20%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Mirror Shot"] = "Mirror Shot deals damage and has a 30%% chance of lowering the target's Accuracy by one stage."
MOVES_DESCRIPTIONS["Rock Throw"] = "Rock Throw deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Earth Power"] = "Earth Power deals damage and has a 10%% chance of lowering the target's Special Defense by one stage."
MOVES_DESCRIPTIONS["Wrap"] = "Wrap deals damage and lower the Speed of the target by two stages."
MOVES_DESCRIPTIONS["Rock Climb"] = "The user attacks the target by smashing into it with incredible force. This may also confuse the target."
MOVES_DESCRIPTIONS["Foul Play"] = "The user turns the target's power against it. The higher the target's Attack stat, the greater the move's power."
MOVES_DESCRIPTIONS["Shadow Claw"] = "The user slashes with a sharp claw made from shadows. Critical hits land more easily."
MOVES_DESCRIPTIONS["Rollout"] = "Rollout inflicts damage over five turns and raises the user's Speed by two stages."
MOVES_DESCRIPTIONS["Wring Out"] = "The power of Wring Out varies between 1 and 120 depending on how much HP the opponent has. The more HP the opponent has, the more damage this move will do. Its damage is calculated by the following formula: Base Power = 120 x (Opponent's Current HP/Opponent's Maximum HP)"
MOVES_DESCRIPTIONS["Psycho Boost"] = "Psycho Boost inflicts damage and lowers the user's Special Attack stat by two stages."
MOVES_DESCRIPTIONS["Light Screen"] = "Light Screen increases user DEFENSE stat."
MOVES_DESCRIPTIONS["Water Pulse"] = "Water Pulse deals damage and has a 20%% chance of confusing the target."
MOVES_DESCRIPTIONS["Scratch"] = "Scratch inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Hi Jump Kick"] = "Hi Jump kick deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Volt Switch"] = "Volt Switch does damage and has no secondary effect."
MOVES_DESCRIPTIONS["Dynamic Punch"] = "Dynamic Punch inflicts damage and confuses the target."
MOVES_DESCRIPTIONS["Doom Desire"] = "Two turns after this move is used, the user blasts the target with a concentrated bundle of light."
MOVES_DESCRIPTIONS["Leech Life"] = "Leech Life inflicts damage, and up to 50%% of the damage dealt to the target is restored to the user as HP."
MOVES_DESCRIPTIONS["Whirlwind"] = "Tackle is one of the most common and basic moves a Pokemon learns. It deals damage with no additional effects."
MOVES_DESCRIPTIONS["Reversal"] = "Reversal deals more damage the lower the target HP."
MOVES_DESCRIPTIONS["Rock Blast"] = "Rock Blast inflicts damage, hitting the target 2-5 times per use."
MOVES_DESCRIPTIONS["Quick Guard"] = "The user protects itself and its allies from the next damage."
MOVES_DESCRIPTIONS["Sweet Kiss"] = "Sweet Kiss causes the target to become confused."
MOVES_DESCRIPTIONS["Signal Beam"] = "Signal Beam deals damage and has a 10%% chance of confusing the target."
MOVES_DESCRIPTIONS["Facade"] = "This attack move doubles its power if the user is poisoned, burned, or paralyzed."
MOVES_DESCRIPTIONS["Nuzzle"] = "Nuzzle inflicts damage and paralyzes its target when it hits."
MOVES_DESCRIPTIONS["Wing Attack"] = "Wing Attack inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Ice Punch"] = "Ice Punch does damage and has a 10%% chance of freezing the target."
MOVES_DESCRIPTIONS["Thunder Fang"] = "Thunder Fang deals damage and has a 10%% chance of paralyzing the target, plus a 10%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Tailwind"] = "Tailwind doubles the speed of all Pokemon in the user's party for 10 seconds."
MOVES_DESCRIPTIONS["Grass Knot"] = "The user snares the target with grass and trips it."
MOVES_DESCRIPTIONS["Wake-Up Slap"] = "Wake-Up Slap deals damage and will have double the power when the target is sleeping. It will also wake the target up."
MOVES_DESCRIPTIONS["Drain Punch"] = "Drain Punch deals damage and the user will recover 50%% of the HP drained."
MOVES_DESCRIPTIONS["Fly"] = "Fly deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Focus Blast"] = "The user heightens its mental focus and unleashes its power. This may also lower the target's Sp. Def stat."
MOVES_DESCRIPTIONS["Barrier"] = "Barrier raises the user's Defense by two stages."
MOVES_DESCRIPTIONS["Sky Drop"] = "The user takes the target into the sky, then drops it during the next turn. The target cannot attack while in the sky."
MOVES_DESCRIPTIONS["Mud Sport"] = "The user kicks up mud on the battlefield. This weakens Electric-type users for five turns."
MOVES_DESCRIPTIONS["Super Fang"] = "Super Fang does damage and has no secondary effect."
MOVES_DESCRIPTIONS["Sludge"] = "Sludge does damage and has a 30%% chance of poisoning the target."
MOVES_DESCRIPTIONS["Close Combat"] = "Close Combat deals damage but lowers the user's Defense and Special Defense by one stage each after attacking."
MOVES_DESCRIPTIONS["Aqua Ring"] = "The user surrounds itself with a veil of water, allowing it to restore 1/16 of its max HP at the end of every turn during 16 turns."
MOVES_DESCRIPTIONS["Magical Leaf"] = "Magical Leaf deals damage and ignores changes to the Accuracy and Evasion stats."
MOVES_DESCRIPTIONS["Conversion2"] = "Changes the user's type to one that is resistant (or immune) to the last move used by the target, randomly."
MOVES_DESCRIPTIONS["Struggle Bug"] = "While resisting, the user attacks the opposing Pokemon. This lowers the Sp. Atk stat of those hit."
MOVES_DESCRIPTIONS["Wild Charge"] = "The user shrouds itself in electricity and smashes into its target."
MOVES_DESCRIPTIONS["Night Shade"] = "Night Shade deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Nightmare"] = "The sleeping opponent loses HP during 5 turns."
MOVES_DESCRIPTIONS["Aqua Tail"] = "Aqua Tail deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Slash"] = "Slash deals damage and has an increased critical hit ratio."
MOVES_DESCRIPTIONS["Magnet Rise"] = "The user levitates using electrically generated magnetism for 10 seconds."
MOVES_DESCRIPTIONS["Iron Defense"] = "Iron Defense raises the user's Defense stat by two stages."
MOVES_DESCRIPTIONS["Secret Power"] = "An attack that may have an additional effect that varies with the terrain."
MOVES_DESCRIPTIONS["Sucker Punch"] = "Sucker Punch deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Roar"] = "Roar lower foe defenses by two stages."
MOVES_DESCRIPTIONS["Dragon Pulse"] = "Dragon Pulse deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Spider Web"] = "Spider Web paralyzes the target."
MOVES_DESCRIPTIONS["Splash"] = "Splash deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Spit Up"] = "Spit Up deals varying damage depending on how many times the user used Stockpile. The base power is 100, 200 or 300 if the user stockpiled one, two or three times respectively."
MOVES_DESCRIPTIONS["Hydro Pump"] = "Hydro Pump inflicts damage and has no secondary effect."
MOVES_DESCRIPTIONS["Spite"] = "The user drain 100-200 energy from the target."
MOVES_DESCRIPTIONS["Nature Power"] = "This attack makes use of nature's power. Its effects vary depending on the user's environment."
MOVES_DESCRIPTIONS["Spore"] = "Spore puts the target to sleep."
MOVES_DESCRIPTIONS["Stockpile"] = "Raises the user's Defense and Special Defense by one stage and charges up power for use with companion moves Spit Up or Swallow."
MOVES_DESCRIPTIONS["Take Down"] = "Take Down deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Low Kick"] = "Low Kick deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Revenge"] = "Revenge charge during 5 turns and then deals damage."
MOVES_DESCRIPTIONS["Sand-Attack"] = "Sand-Attack lowers the target's Accuracy by one stage."
MOVES_DESCRIPTIONS["Fury Swipes"] = "Fury Swipes inflicts damage, hitting 2-5 times per use."
MOVES_DESCRIPTIONS["Flame Burst"] = "Flame Burst deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Reflect Type"] = "The user reflects the target's type, making it the same type as the target."
MOVES_DESCRIPTIONS["Sky Attack"] = "Nothing will happen on the first turn. On the second turn, Sky Attack deals damage and has a 30%% chance of causing the target to flinch."
MOVES_DESCRIPTIONS["Ice Ball"] = "Ice Ball does damage and has no secondary effect."
MOVES_DESCRIPTIONS["Recover"] = "User recovers 50%% of its max HP."
MOVES_DESCRIPTIONS["Shadow Sneak"] = "Shadow Sneak deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Ice Shard"] = "Ice Shard deals damage and has no secondary effect."
MOVES_DESCRIPTIONS["Razor Wind"] = "The user of Razor Wind will 'whip up a whirlwind' on the first turn. On the second turn, Razor Wind deals damage and has an increased critical hit ratio."
MOVES_DESCRIPTIONS["Mirror Coat"] = "Any move is reflected back to the attacker."

function getMoveDescriptionByName(name)
    return MOVES_DESCRIPTIONS[name] and tr(MOVES_DESCRIPTIONS[name]) or ""
end