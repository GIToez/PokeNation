local SPECIAL_ABILITIES = {
    [POKEMON_SPECIAL_ABILITY_IDS.NONE] = {
        name = "None",
        description = "None"
    },
    [POKEMON_SPECIAL_ABILITY_IDS.OVERGROW] = {
        name = "Overgrow",
        description = "When a Pokemon with Overgrow uses a Grass-type move, the power will increase by 1.5x if the user has less than or equal to 1/3 of its maximum HP remaining.",
        onCheck = function(cid, target, move)
            return (getPokemonSkillDamageType(move) == ELEMENT_GRASS) and
                    (getCreatureHealth(cid) <= (getCreatureMaxHealth(cid) * 0.3))
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.BLAZE] = {
        name = "Blaze",
        description = "When a Pokemon with Blaze uses a Fire-type move, the power will increase by 1.5x if the user has less than or equal to 1/3 of its maximum HP remaining.",
        onCheck = function(cid, target, move)
            return (getPokemonSkillDamageType(move) == ELEMENT_FIRE) and
                    (getCreatureHealth(cid) <= (getCreatureMaxHealth(cid) * 0.3))
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.TORRENT] = {
        name = "Torrent",
        description = "When a Pokemon with Torrent uses a Water-type move, the power will increase by 1.5x if the user has less than or equal to 1/3 of its maximum HP remaining.",
        onCheck = function(cid, target, move)
            return (getPokemonSkillDamageType(move) == ELEMENT_WATER) and
                    (getCreatureHealth(cid) <= (getCreatureMaxHealth(cid) * 0.3))
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SHIELD_DUST] = {
        name = "Shield Dust",
        description = "Shield Dust negates all possible side-effects. For example, Body Slam would only deal damage and not have its usual 30% chance of causing Paralysis. It does not stop moves that only cause these effects, like Thunder Wave.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SHED_SKIN] = {
        name = "Shed Skin",
        description = "There is a 30% chance that Shed Skin will cure the user of a non-volatile status ailment at application time.",
        onCheck = function(cid, target, status)
            return not getStatusAilmentVolatile(status) and getRandom(0, 100) <= 30
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.COMPOUNDEYES] = {
        name = "Compoundeyes",
        description = "Compoundeyes prevents loss of Accuracy.",
        onCheck = function(cid, target, status)
            return status == CREATURE_STATUS_LOWACCURACY
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SWARM] = {
        name = "Swarm",
        description = "When a Pokemon with Swarm uses a Bug-type move, the power will increase by 1.5x if the user has less than or equal to 1/3 of its maximum HP remaining.",
        onCheck = function(cid, target, move)
            return (getPokemonSkillDamageType(move) == ELEMENT_BUG) and
                    (getCreatureHealth(cid) <= (getCreatureMaxHealth(cid) * 0.3))
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.KEEN_EYE] = {
        name = "Keen Eye",
        description = "Keen Eye prevents loss of Accuracy.",
        onCheck = function(cid, target, status)
            return status == CREATURE_STATUS_LOWACCURACY
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.TANGLED_FEET] = {
        name = "Tangled Feet",
        description = "When a Pokemon with Tangled Feet gets Confusion, the user grants 20% chance of evasive from moves.",
        onCheck = function(cid, target)
            return getCreatureCondition(cid, CREATURE_STATUS_CONFUSION) and getRandom(0, 100) <= 20
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.RUN_AWAY] = {
        name = "Run Away",
        description = "Run Away prevents loss of Speed.",
        onCheck = function(cid, target, status)
            return status == CREATURE_STATUS_PARALYSIS or status == CREATURE_STATUS_EXTRASPEED
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.GUTS] = {
        name = "Guts",
        description = "Guts raises the Attack stat by 50% while affected by the burn, paralysis, poison, or sleep status ailments.",
        onCheck = function(cid, target)
            return getCreatureStatus(cid, CREATURE_STATUS_BURN) or
                    getCreatureStatus(cid, CREATURE_STATUS_PARALYSIS) or
                    getCreatureStatus(cid, CREATURE_STATUS_POISON) or
                    getCreatureStatus(cid, CREATURE_STATUS_BADPOISON) or
                    getCreatureStatus(cid, CREATURE_STATUS_SLEEP)
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.INTIMIDATE] = {
        name = "Intimidate",
        description = "Intimidate lowers the opponent's Attack stat by one stage. It affect all opponents in the battle and has no effect on Pokemon who are immune to Attack stat reductions, such as Pokemon with Clear Body, Hyper Cutter, or White Smoke. This ability is triggered when the user attack.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.STATIC] = {
        name = "Static",
        description = "When Pokemon with this Ability are hit by a move that makes contact, there is a 30% chance that the attacking foe will become paralyzed. This can affect Ground-type Pokemon.",
        onCheck = function(cid, target, move)
            return getPokemonSkillMakeContact(move) and getRandom(0, 100) <= 30
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SAND_VEIL] = {
        name = "Sand Veil",
        description = "Sand Veil grants a 10% chance of decreasing the opponent accuraccy when hit by a damaging Ground-Type move.",
        onCheck = function(cid, target, move)
            return getPokemonSkillDamageType(move) == ELEMENT_GROUND and getRandom(0, 100) <= 10
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.POISON_POINT] = {
        name = "Poison Point",
        description = "When a Pokemon with Poison Point is hit by a move that makes contact, there is a 30% chance that the attacking foe will become poisoned.",
        onCheck = function(cid, target, move)
            return getPokemonSkillMakeContact(move) and getRandom(0, 100) <= 30
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.RIVALRY] = {
        name = "Rivalry",
        description = "Rivalry raises the base power of a move by 25% if the foe and the user have the same gender, but reduces base power by 25% if the foe and the user have opposite genders. If the user or the foe is genderless, the move's base power is unaffected.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.CUTE_CHARM] = {
        name = "Cute Charm",
        description = "When a Pokemon with Cute Charm is hit by a move that makes contact, there is a 30% chance that the opponent of the opposite gender will become infatuated.",
        onCheck = function(cid, target, move)
            return getPokemonSkillMakeContact(move) and getMonsterSex(cid) ~= getMonsterSex(target) and
                    getRandom(0, 100) <= 30
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.MAGIC_GUARD] = {
        name = "Magic Guard",
        description = "Magic Guard prevents indirect damage, such as from Curse or Leech Seed.",
        onCheck = function(cid, target, move)
            return getPokemonSkillMakeIndirectDamage(move)
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.FLASH_FIRE] = {
        name = "Flash Fire",
        description = "Flash Fire raises dealing damages done to Fire-Type opponents by 50%.",
        onCheck = function(cid, target)
            return isInArray(getPokemonTypes(target), ELEMENT_FIRE)
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.INNER_FOCUS] = {
        name = "Inner Focus",
        description = "Inner Focus prevents flinching.",
        onCheck = function(cid, target, status)
            return status == CREATURE_STATUS_FLINCH
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.CHLOROPHYLL] = {
        name = "Chlorophyll",
        description = "When a Pokemon with Chlorophyll is hit by a Water-type move, the user receives extra speed during 10 seconds.",
        onCheck = function(cid, target, move)
            return getPokemonSkillDamageType(move) == ELEMENT_WATER
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.EFFECT_SPORE] = {
        name = "Effect Spore",
        description = "Effect Spore may inflict the foe with a status problem if they make contact. It has a 30% chance of inducing either Paralysis, Sleep or Poison on the opponent when hit with a move that makes contact.",
        onCheck = function(cid, target, move)
            return getPokemonSkillMakeContact(move) and getRandom(0, 100) <= 30
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.DRY_SKIN] = {
        name = "Dry Skin",
        description = "Dry Skin make Fire-type attacks do 25% more damage to these Pokemon, while Water-type attacks will have no effect and heal 1/4 of their damage instead.",
        onCheck = function(cid, target, move)
            return isInArray({ ELEMENT_WATER, ELEMENT_FIRE }, getPokemonSkillDamageType(move))
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.TINTED_LENS] = {
        name = "Tinted Lens",
        description = "Tinted Lens doubles the power of any moves that the Pokemon uses that are 'not very effective' against its targets. If a move is regularly not very effective, and thus normally does half damage, it would therefore do normal damage, while a doubly-resisted move (such as a Bug-type move against the Steel/Flying Skarmory) will do half damage rather than one quarter damage.",
        onCheck = function(cid, target, elementMultiplier)
            return elementMultiplier > 0 and elementMultiplier <= 0.5
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.ARENA_TRAP] = {
        name = "Arena Trap",
        description = "Arena Trap grants a 10% chance of decreasing the opponent speed by one stage when hit by a damaging Ground-Type move.",
        onCheck = function(cid, target, move)
            return getPokemonSkillDamageType(move) == ELEMENT_GROUND and getRandom(0, 100) <= 10
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.TECHNICIAN] = {
        name = "Technician",
        description = "Technician increases the base power of all moves which have a base power of 60 or less by 1.5x. For moves with variable base power, Technician will only apply if the base power is 60 or less when used.",
        onCheck = function(cid, target, power)
            return power <= 60
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.LIMBER] = {
        name = "Limber",
        description = "Limber prevents paralysis.",
        onCheck = function(cid, target, status)
            return status == CREATURE_STATUS_PARALYSIS
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.DAMP] = {
        name = "Damp",
        description = "Damp prevents self-destruction and the use of moves such as Selfdestruct and Explosion. If Selfdestruct or Explosion are selected in battle, the attack will fail and the user will not faint.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.CLOUD_NINE] = {
        name = "Cloud Nine",
        description = "Cloud Nine prevents the Defense stat from being reduced(except those self-inflicted).",
        onCheck = function(cid, target, status, caster)
            return status == CREATURE_STATUS_EXTRASPDEF and cid ~= caster
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.VITAL_SPIRIT] = {
        name = "Vital Spirit",
        description = "Vital Spirit prevents Sleep. If a Pokemon with Vital Spirit uses Rest, it will automatically fail.",
        onCheck = function(cid, target, status)
            return status == CREATURE_STATUS_SLEEP
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.ANGER_POINT] = {
        name = "Anger Point",
        description = "Anger Point maximizes the Attack stat of Pokemon with this Ability when they are hit by a critical hit.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.WATER_ABSORB] = {
        name = "Water Absorb",
        description = "Water Absorb heals one quarter of the damage when hit with a Water-type attack. Therefore, the user does not take damage from Water-type moves.",
        onCheck = function(cid, target, move)
            return getPokemonSkillDamageType(move) == ELEMENT_WATER
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SYNCHRONIZE] = {
        name = "Synchronize",
        description = "Synchronize passes on status problems to the opponent that caused the problem. Synchronize will not pass on the Sleep or Frozen status conditions. Synchronize will have no effect if the other Pokemon has a type or Ability that prevents them from being Poisoned, Paralyzed, or Burned.",
        onCheck = function(cid, target, status, caster)
            return cid ~= caster and status ~= CREATURE_STATUS_SLEEP and status ~= CREATURE_STATUS_FREEZE
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.PICKUP] = {
        name = "Pickup",
        description = "When an opponent uses a Berry, Pokemon with Pickup gain the used Berry effect.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.NO_GUARD] = {
        name = "No Guard",
        description = "All moves used by or against a Pokemon with No Guard cannot miss.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.CLEAR_BODY] = {
        name = "Clear Body",
        description = "Clear Body prevents stat reduction caused by another Pokemon's move or Ability. Stat reductions can only be caused on Pokemon with this Ability if they are self-inflicted, such as from moves like Superpower.",
        onCheck = function(cid, target, status, caster)
            return cid ~= caster and
                    (status == CREATURE_STATUS_EXTRASPATK or status == CREATURE_STATUS_EXTRASPDEF or
                            status == CREATURE_STATUS_EXTRASPEED)
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.LIQUID_OOZE] = {
        name = "Liquid Ooze",
        description = "Liquid Ooze causes HP-draining moves to cause injury. If a Pokemon with Liquid Ooze is hit by an HP-draining move such as Leech Life or Giga Drain, the amount of HP that should be recovered by the opponent will be dealt as damage instead. However, Liquid Ooze does not prevent damage to the Pokemon. Dream Eater is not affected by this Ability.",
        onCheck = function(cid, target, move)
            return move ~= "Dream Eater"
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.ROCK_HEAD] = {
        name = "Rock Head",
        description = "Rock Head increases the damage of moves that naturally should do recoil like Hi Jump Kick and Double-Edge by 20%.",
        onCheck = function(cid, target, move)
            return getPokemonSkillMakeRecoil(move)
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.STURDY] = {
        name = "Sturdy",
        description = "Sturdy prevents the user to be fainted by one hit moves, instead the user will become with 1 HP. This ability does not work if the Pokemon HP is already very low.",
        onCheck = function(cid, target, damage)
            local health = getCreatureHealth(cid)
            return health > 1600 and (health + damage) <= 0
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.OBLIVIOUS] = {
        name = "Oblivious",
        description = "A Pokemon with Oblivious is immune to effects that only work on opposite gendered Pokemon; specifically Cute Charm, Attract, and Captivate.",
        onCheck = function(cid, target, move)
            return not move or isInArray({ "Attract", "Captivate" }, move) -- 'Not move' means that this is checking from Cute Charm ability
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.OWN_TEMPO] = {
        name = "Own Tempo",
        description = "Own Tempo prevents confusion, even if it is self-inflicted (such as from Thrash or a Berry).",
        onCheck = function(cid, target, status)
            return status == CREATURE_STATUS_CONFUSION
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.MAGNET_PULL] = {
        name = "Magnet Pull",
        description = "Magnet Pull decreases Steel-type Pokemon speed by one stage. This ability is triggered when the user attack.",
        onCheck = function(cid, target)
            return isInArray(getPokemonTypes(target), ELEMENT_STEEL)
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.EARLY_BIRD] = {
        name = "Early Bird",
        description = "Early Bird causes quick awakening from sleep.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.THICK_FAT] = {
        name = "Thick Fat",
        description = "Thick Fat gives the user heat and cold protection, therefore halving the power of Ice-type and Fire-type moves.",
        onCheck = function(cid, target, move)
            return isInArray({ ELEMENT_FIRE, ELEMENT_ICE }, getPokemonSkillDamageType(move))
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.HYDRATION] = {
        name = "Hydration",
        description = "Hydration cures any status ailment that the Pokemon with this Ability has after hit with a Water-type attack, even self inflicted status such as from using Rest.",
        onCheck = function(cid, target, move)
            return getPokemonSkillDamageType(move) == ELEMENT_WATER
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.STENCH] = {
        name = "Stench",
        description = "Stench has a 10% chance of flinching the opponent when hit by a damaging move.",
        onCheck = function(cid, target)
            return getRandom(0, 100) <= 10
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.STICKY_HOLD] = {
        name = "Sticky Hold",
        description = "This Ability prevents the user's held item from being taken.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SHELL_ARMOR] = {
        name = "Shell Armor",
        description = "Pokemon with Shell Armor will never be hit by a critical hit.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SKILL_LINK] = {
        name = "Skill Link",
        description = "Skill Link causes multi-strike moves to always strike their maximum number of times. This Ability does not affect moves with a fixed number of strikes like Double Kick.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.LEVITATE] = {
        name = "Levitate",
        description = "Levitate renders the user immune to Ground-type moves.",
        onCheck = function(cid, target, move)
            return getPokemonSkillDamageType(move) == ELEMENT_GROUND
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.INSOMNIA] = {
        name = "Insomnia",
        description = "Insomnia prevents Sleep by either the opponent or themselves. If a Pokemon with Insomnia uses Rest, it will automatically fail.",
        onCheck = function(cid, target, status)
            return status == CREATURE_STATUS_SLEEP
        end
    },
    --[[[POKEMON_SPECIAL_ABILITY_IDS.FOREWARN] = {
        name = "Forewarn",
        description = "Forewarn shows the opponent's move with he learn by TM.",
        onCheck = function(cid, target, move)
            return true
        end
    },]]
    [POKEMON_SPECIAL_ABILITY_IDS.HYPER_CUTTER] = {
        name = "Hyper Cutter",
        description = "Hyper Cutter prevents the Attack stat from being reduced (except those self-inflicted) from moves such as Growl or Abilities such as Intimidate.",
        onCheck = function(cid, target, status, caster)
            return status == CREATURE_STATUS_EXTRASPATK and cid ~= caster
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SOUNDPROOF] = {
        name = "Soundproof",
        description = "Soundproof prevents all effect from sound moves, granting the user immunity from them.",
        --[[onCheck = function(cid, target, move) Isn't used
            return getPokemonSkillMakeSound(move)
        end]]
    },
    [POKEMON_SPECIAL_ABILITY_IDS.LIGHTNINGROD] = {
        name = "Lightningrod",
        description = "Lightningrod gives the Pokemon immunity to all Electric-type attacks and raises the Pokemon's Special Attack by one stage whenever they are hit by one.",
        onCheck = function(cid, target, move)
            return getPokemonSkillDamageType(move) == ELEMENT_ELECTRIC
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.LIMBER] = {
        name = "Limber",
        description = "Limber prevents paralysis.",
        onCheck = function(cid, target, status)
            return status == CREATURE_STATUS_PARALYSIS
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.RECKLESS] = {
        name = "Reckless",
        description = "Reckless increases the base power of moves which cause recoil or crash damage by 20%.",
        onCheck = function(cid, target, move)
            return getPokemonSkillMakeRecoil(move)
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.IRON_FIST] = {
        name = "Iron Fist",
        description = "Iron Fist causes the Base Power of affected punching moves to increase by 20%.",
        onCheck = function(cid, target, move)
            return getPokemonSkillMakePunch(move)
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.NATURAL_CURE] = {
        name = "Natural Cure",
        description = "Natural Cure heals any status ailments upon switching out.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SERENA_GRACE] = {
        name = "Serena Grace",
        description = "Serene Grace will double the chance of a move having an additional effect. For example, Psychic will have a 20% chance of lowering the target's Special Defense stat instead of its usual 10% chance, and Rock Smash will always lower an opponent's Defense by 1 level, as opposed to having a 50% chance of doing so.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.LEAF_GUARD] = {
        name = "Leaf Guard",
        description = "When a Pokemon with Leaf Guard is hit by a Water-type move, the user cures all non-volatile status problems.",
        onCheck = function(cid, target, move)
            return getPokemonSkillDamageType(move) == ELEMENT_WATER
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SCRAPPY] = {
        name = "Scrappy",
        description = "Scrappy causes Ghost-type Pokemon to be hit by damage-dealing Normal- and Fighting-type moves inflicted by the user.",
        onCheck = function(cid, target, move)
            return isInArray(getPokemonTypes(target), ELEMENT_GHOST) and
                    isInArray({ ELEMENT_FIGHT, ELEMENT_NORMAL }, getPokemonSkillDamageType(move))
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SWIFT_SWIM] = {
        name = "Swift Swim",
        description = "Swift Swim increase the user's Speed stat when hit by Water-Type moves.",
        onCheck = function(cid, target, move)
            return getPokemonSkillDamageType(move) == ELEMENT_WATER
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SNIPER] = {
        name = "Sniper",
        description = "Critical hits will do higher damage than normal.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.WATER_VEIL] = {
        name = "Water Veil",
        description = "Water Veil prevents burns.",
        onCheck = function(cid, target, status)
            return status == CREATURE_STATUS_BURN
        end
    },
    --[[ [POKEMON_SPECIAL_ABILITY_IDS.ILLUMINATE] = {
        name = "Illuminate",
        description = "",
        onCheck = function(cid, move)
            return true
        end
    }, ]]
    [POKEMON_SPECIAL_ABILITY_IDS.FILTER] = {
        name = "Filter",
        description = "Filter reduces super effective damage by 1/4. A move that would deal 2x damage will instead deal 1.5x damage.",
        onCheck = function(cid, target, elementMultiplier)
            return elementMultiplier >= 2.0
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.TRACE] = {
        name = "Trace",
        description = "Trace copies the Ability of the current opponent when hit. If both the Pokemon and the opponent have Trace, it will do nothing.",
        onCheck = function(cid, target)
            return not table.find({
                POKEMON_SPECIAL_ABILITY_IDS.TRACE, POKEMON_SPECIAL_ABILITY_IDS.NONE,
                POKEMON_SPECIAL_ABILITY_IDS.SUMMI
            }, getMonsterSpecialAbility(target))
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.DOWNLOAD] = {
        name = "Download",
        description = "Download raises the Attack stat by one stage if the foe's defensive stats is higher than the user attack. This ability is triggered when the user attack.",
        onCheck = function(cid, target)
            local cidName, cidLevel = getCreatureName(cid), getMonsterLevel(cid)
            local targetName, targetLevel = getCreatureName(target), getMonsterLevel(target)
            return (getPokemonSpAtk(cid, cidLevel) < getPokemonSpDef(target, targetLevel)) or
                    (getPokemonAtk(cid, cidLevel) < getPokemonDef(target, targetLevel))
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.BATTLE_ARMOR] = {
        name = "Battle Armor",
        description = "Battle Armor prevents the opponent from landing a critical hit.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.PRESSURE] = {
        name = "Pressure",
        description = "Pressure increases foes cooldown usage by 50% for moves targeting the Pokemon with Pressure.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.IMMUNITY] = {
        name = "Immunity",
        description = "Immunity prevents poisoning.",
        onCheck = function(cid, target, status)
            return status == CREATURE_STATUS_POISON or status == CREATURE_STATUS_BADPOISON
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.FLAME_BODY] = {
        name = "Flame Body",
        description = "When a Pokemon with Flame Body is hit by a move that makes contact, there is a 30% chance that the attacking foe will become burned.",
        onCheck = function(cid, target, move)
            return getPokemonSkillMakeContact(move) and getRandom(0, 100) <= 30
        end
    },
    --[[[POKEMON_SPECIAL_ABILITY_IDS.MOLD_BREAKER] = {
        name = "Mold Breaker",
        description = "Mold Breaker negates the effects of Abilities that could potentially weaken or negate moves or the side-effects of moves that the Mold Breaker Pokemon use (Mold Breaker will allow the user's Earthquake to hit a Pokemon with Levitate, but has no effect on the player's ally's Earthquake).",
    },]]
    [POKEMON_SPECIAL_ABILITY_IDS.ADAPTABILITY] = {
        name = "Adaptability",
        description = "Adaptability double moves power that type equal user type.",
        onCheck = function(cid, target, move)
            return isInArray(getPokemonTypes(cid), getPokemonSkillDamageType(move))
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.VOLT_ABSORB] = {
        name = "Volt Absorb",
        description = "Volt Absorb heals one quarter of the damage when hit with a Electric-type attack. Therefore, the user does not take damage from Electric-type moves.",
        onCheck = function(cid, target, move)
            return getPokemonSkillDamageType(move) == ELEMENT_ELECTRIC
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.HUSTLE] = {
        name = "Hustle",
        description = "Hustle increases the user's damage by 50% when under low Accuracy conditions.",
        onCheck = function(cid, target)
            return getCreatureStatus(cid, CREATURE_STATUS_LOWACCURACY)
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.HUGE_POWER] = {
        name = "Huge Power",
        description = "Huge Power increases the base power of physical moves by 1.5x.",
        onCheck = function(cid, target, move)
            return getPokemonSkillCategory(move) == MOVE_CATEGORY.PHYSICAL
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SPEED_BOOST] = {
        name = "Speed Boost",
        description = "Speed Boost raises the user's Speed stat by one stage while in battle. This special ability is triggered when the user make a move.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SUPER_LUCK] = {
        name = "Super Luck",
        description = "Super Luck increases the critical hit ratio by 20%.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SHADOW_TAG] = {
        name = "Shadow Tag",
        description = "Shadow Tag protect the user against paralyze and speed reduction conditions.",
        onCheck = function(cid, target, status)
            return status == CREATURE_STATUS_PARALYSIS or status == CREATURE_STATUS_EXTRASPEED
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.QUICK_FEET] = {
        name = "Quick Feet",
        description = "Quick Feet increases the user's Speed stat when the user is inflicted with a status ailment.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.GLUTTONY] = {
        name = "Gluttony",
        description = "Gluttony boost the healing power of berries eat by the user within 50%.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.MAGMA_ARMOR] = {
        name = "Magma Armor",
        description = "Magma Armor prevents freezing.",
        onCheck = function(cid, target, status)
            return status == CREATURE_STATUS_FREEZE
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SNOW_CLOAK] = {
        name = "Snow Cloak",
        description = "Snow Cloak grants 5% chance of evasion from moves.",
        onCheck = function(cid, target)
            return getRandom(0, 100) <= 5
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.STEADFAST] = {
        name = "Steadfast",
        description = "Steadfast increases the user's Speed stat when flinched.",
        onCheck = function(cid, target, status)
            return status == CREATURE_STATUS_FLINCH
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SAND_STREAM] = {
        name = "Sand Stream",
        description = "Sand Stream grants a 10% chance of decreasing the opponent accuraccy when hit by a damaging move.",
        onCheck = function(cid, target)
            return getRandom(0, 100) <= 10
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SUMMI] = {
        name = "Summi",
        description = "Summi ensures mysterious powers to its wearer, ensuring large immunities and special abilities.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.DAMAGEONE] = {
        name = "Damage One",
        description = "Damage One ensures mysterious powers to its wearer, ensuring large immunities and special abilities.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.PURE_POWER] = {
        name = "Pure Power",
        description = "Using its pure power, the Pokemon doubles its Attack stat.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.MINUS] = {
        name = "Minus",
        description = "Boosts the Sp. Atk stat of the Pokemon if an ally with the Plus or Minus Ability is also in battle.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.PLUS] = {
        name = "Plus",
        description = "Boosts the Sp. Atk stat of the Pokemon if an ally with the Plus or Minus Ability is also in battle.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.NORMALIZE] = {
        name = "Normalize",
        description = "All the Pokemon's moves become Normal type. The power of those moves is boosted by 20%.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.RAIN_DISH] = {
        name = "Rain Dish",
        description = "Rain Dish heals 1/4 of the damage when hit with a Water-type attack.",
        onCheck = function(cid, target, move)
            return getPokemonSkillDamageType(move) == ELEMENT_WATER
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.ICE_BODY] = {
        name = "Ice Body",
        description = "Ice Body heals 1/4 of the damage when hit with a Ice-type attack.",
        onCheck = function(cid, target, move)
            return getPokemonSkillDamageType(move) == ELEMENT_ICE
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SOLAR_POWER] = {
        name = "Solar Power",
        description = "Solar Power increases the Pokemon's Special Attack when hit with a Fire-type attack.",
        onCheck = function(cid, target, move)
            return getPokemonSkillDamageType(move) == ELEMENT_FIRE
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.WONDER_GUARD] = {
        name = "Wonder Guard",
        description = "Its mysterious power only lets supereffective moves hit the Pokemon.",
        onCheck = function(cid, target, elementMultiplier)
            return elementMultiplier < 2.0
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.DROUGHT] = {
        name = "Drought",
        description = "Drought boosts Fire-type moves power by 20%.",
        onCheck = function(cid, target, move)
            return getPokemonSkillDamageType(move) == ELEMENT_FIRE
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.COLOR_CHANGE] = {
        name = "Color Change",
        description = "The Pokemon's type becomes the type of the move used on it.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.ROUGH_SKIN] = {
        name = "Rough Skin",
        description = "This Pokemon inflicts damage with its rough skin to the attacker on contact.",
        onCheck = function(cid, target, move)
            return getPokemonSkillMakeContact(move)
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SIMPLE] = {
        name = "Simple",
        description = "The stat changes the Pokemon receives are doubled.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.FORECAST] = {
        name = "Forecast",
        description = "The Pokemon transforms with the weather to change its type to Water, Fire, or Ice.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.POISON_HEAL] = {
        name = "Poison Heal",
        description = "Restores HP if the Pokemon is poisoned, instead of losing HP.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.DRIZZLE] = {
        name = "Drizzle",
        description = "Drizzle boosts Water-type moves power by 20%.",
        onCheck = function(cid, target, move)
            return getPokemonSkillDamageType(move) == ELEMENT_WATER
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.AIR_LOOK] = {
        name = "Air Look",
        description = "",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.COMPETITIVE] = {
        name = "Competitive",
        description = "Boosts the Sp. Atk stat sharply when a stat is lowered.",
        onCheck = function(cid, target, status)
            return table.find({ CREATURE_STATUS_EXTRASPATK, CREATURE_STATUS_EXTRASPDEF, CREATURE_STATUS_EXTRASPEED }, status)
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.STALL] = {
        name = "Stall",
        description = "Stall increases foes cooldown usage by 10% for moves targeting the Pokemon with Pressure.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.ANTICIPATION] = {
        name = "Anticipation",
        description = "Anticipation reduces super effective damage by 1/6.",
        onCheck = function(cid, target, elementMultiplier)
            return elementMultiplier >= 2.0
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.ILLUMINATE] = {
        name = "Illuminate",
        description = "Illuminate increases user damage on wild Pokemon by 30%.",
        onCheck = function(cid, target)
            return isPokemonWild(target)
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.SUCTION_CUPS] = {
        name = "Suction Cups",
        description = "Suction Cups protect the user against paralyze condition.",
        onCheck = function(cid, target, status)
            return status == CREATURE_STATUS_PARALYSIS
        end
    },
    [POKEMON_SPECIAL_ABILITY_IDS.FRISK] = {
        name = "Frisk",
        description = "Frisk protects the user from Held Item effects.",
    },
    [POKEMON_SPECIAL_ABILITY_IDS.TRUANT] = {
        name = "Truant",
        description = "Truant has a 10% chance of leaving the user tired after using some move.",
        onCheck = function(cid, target)
            return getRandom(1, 100) <= 10
        end
    },
}

function getPokemonSpecialAbilityName(ability)
    if (not SPECIAL_ABILITIES[ability]) then
        log(LOG_TYPES.ERROR, "SpecialAbilities::getPokemonSpecialAbilityName - Unknown Special Ability", ability)
        return ""
    end

    return SPECIAL_ABILITIES[ability].name or ""
end

function getPokemonSpecialAbilityDescription(ability)
    return SPECIAL_ABILITIES[ability].description or ""
end

function doPokemonSpecialAbilityCheck(cid, ability, target, ...)
    if (not ability) then
        log(LOG_TYPES.ERROR, "doPokemonSpecialAbilityCheck - Nil ability", getCreatureName(cid), ability, ...)
        return false
    end

    return isMonster(cid) and getMonsterSpecialAbility(cid) == ability and (not target or isMonster(target)) and
            (not SPECIAL_ABILITIES[ability].onCheck or SPECIAL_ABILITIES[ability].onCheck(cid, target, ...))
end

--doCheckPokemonSpecialAbilities();