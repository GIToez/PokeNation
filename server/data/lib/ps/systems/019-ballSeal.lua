local AREAS = {
    --Circles
    CIRCLE2X2 = {
        {0, 1, 1, 1, 0},
        {1, 1, 1, 1, 1},
        {1, 1, 3, 1, 1},
        {1, 1, 1, 1, 1},
        {0, 1, 1, 1, 0}
    },

    CIRCLE3X3 = {
        {0, 0, 1, 1, 1, 0, 0},
        {0, 1, 1, 1, 1, 1, 0},
        {1, 1, 1, 1, 1, 1, 1},
        {1, 1, 1, 3, 1, 1, 1},
        {1, 1, 1, 1, 1, 1, 1},
        {0, 1, 1, 1, 1, 1, 0},
        {0, 0, 1, 1, 1, 0, 0}
    },

    CIRCLE1X1 = {
        {0, 1, 0},
        {1, 3, 1},
        {0, 1, 0},
    },

    CIRCLE2X2_EMPTY = {
        {0, 1, 1, 1, 0},
        {1, 0, 0, 0, 1},
        {1, 0, 3, 0, 1},
        {1, 0, 0, 0, 1},
        {0, 1, 1, 1, 0}
    },

    CIRCLE3X3_EMPTY = {
        {0, 0, 1, 1, 1, 0, 0},
        {0, 1, 0, 0, 0, 1, 0},
        {1, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 3, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 1},
        {0, 1, 0, 0, 0, 1, 0},
        {0, 0, 1, 1, 1, 0, 0}
    },

    CIRCLE4X4_EMPTY = {
        {0, 0, 1, 1, 1, 1, 1, 0, 0},
        {0, 1, 0, 0, 0, 0, 0, 1, 0},
        {1, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 3, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 0, 0, 1},
        {0, 1, 0, 0, 0, 0, 0, 1, 0},
        {0, 0, 1, 1, 1, 1, 1, 0, 0}
    },

    -- Crosses
    CROSS1X1 = {
        {0, 1, 0},
        {1, 3, 1},
        {0, 1, 0}
    },

    CROSS1X1_DIAGONAL = {
        {1, 0, 1},
        {0, 3, 0},
        {1, 0, 1}
    },

    CROSS2X2_DIAGONAL = {
        {1, 0, 0, 0, 1},
        {0, 1, 0, 1, 0},
        {0, 0, 3, 0, 0},
        {0, 1, 0, 1, 0},
        {1, 0, 0, 0, 1}
    },

    CROSS4X4 = {
        {0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 1, 1, 1, 0, 0, 0},
        {0, 0, 1, 1, 1, 1, 1, 0, 0},
        {0, 1, 1, 1, 1, 1, 1, 1, 0},
        {0, 1, 1, 1, 3, 1, 1, 1, 0},
        {0, 1, 1, 1, 1, 1, 1, 1, 0},
        {0, 0, 1, 1, 1, 1, 1, 0, 0},
        {0, 0, 0, 1, 1, 1, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0},
    },

    --Squares
    SQUARE1X1 = {
        {1, 1, 1},
        {1, 3, 1},
        {1, 1, 1}
    },

    SQUARE2X2_EMPTY = {
        {1, 1, 1, 1, 1},
        {1, 0, 0, 0, 1},
        {1, 0, 3, 0, 1},
        {1, 0, 0, 0, 1},
        {1, 1, 1, 1, 1}
    },

    LOVE_HEART = {
        {0, 1, 0, 0, 0, 1, 0},
        {1, 0, 1, 1, 1, 0, 1},
        {1, 0, 0, 0, 0, 0, 1},
        {1, 0, 0, 0, 0, 0, 1},
        {0, 1, 0, 0, 0, 1, 0},
        {0, 0, 1, 0, 1, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
    },

    LINE1 = {
        {0, 1, 0},
        {1, 0, 1},
        {0, 1, 0},
    },

    LINE2 = {
        {0, 0, 1, 0, 0},
        {0, 0, 0, 0, 0},
        {1, 0, 0, 0, 1},
        {0, 0, 0, 0, 0},
        {0, 0, 1, 0, 0},
    },

    LINE3 = {
        {0, 0, 0, 1, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {1, 0, 0, 0, 0, 0, 1},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 1, 0, 0, 0},
    },

    LINE4 = {
        {0, 0, 0, 0, 1, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0},
        {1, 0, 0, 0, 0, 0, 0, 0, 1},
        {0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 0, 0, 0, 0, 0},
        {0, 0, 0, 0, 1, 0, 0, 0, 0},
    },

    CLOCKWISE1 = {
        {0, 1, 0},
        {0, 0, 0},
        {0, 0, 0},
    },

    CLOCKWISE2 = {
        {0, 0, 1},
        {0, 0, 0},
        {0, 0, 0},
    },

    CLOCKWISE3 = {
        {0, 0, 0},
        {0, 0, 1},
        {0, 0, 0},
    },

    CLOCKWISE4 = {
        {0, 0, 0},
        {0, 0, 0},
        {0, 0, 1},
    },

    CLOCKWISE5 = {
        {0, 0, 0},
        {0, 0, 0},
        {0, 1, 0},
    },

    CLOCKWISE6 = {
        {0, 0, 0},
        {0, 0, 0},
        {1, 0, 0},
    },

    CLOCKWISE7 = {
        {0, 0, 0},
        {1, 0, 0},
        {0, 0, 0},
    },

    CLOCKWISE8 = {
        {1, 0, 0},
        {0, 0, 0},
        {0, 0, 0},
    },
}

local BALL_SEALS = {
    [BALL_SEAL_IDS.HEART_A] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_LOVE_HEARTS_FOUR)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_LOVE_HEARTS_FOUR)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE3X3_EMPTY, doSendMagicEffect, EFFECT_LOVE_HEARTS_FOUR)
                end
            },
        },
        itemid = 17386
    },
	[BALL_SEAL_IDS.HEART_B] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_GRAVEL)
                        doSendMagicEffect(newPos, EFFECT_LOVE_HEARTS)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_GRAVEL)
                        doSendMagicEffect(newPos, EFFECT_LOVE_HEARTS)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_GRAVEL)
                        doSendMagicEffect(newPos, EFFECT_LOVE_HEARTS)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_GRAVEL)
                        doSendMagicEffect(newPos, EFFECT_LOVE_HEARTS)
                    end
                end
            },
        },
        itemid = 17387
    },
	[BALL_SEAL_IDS.HEART_C] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_LOVE_HEARTS_FOUR)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_LOVE_HEARTS_FOUR)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE3X3_EMPTY, doSendMagicEffect, EFFECT_LOVE_HEARTS_FOUR)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_LOVE_HEARTS_FOUR)
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_LOVE_HEARTS_FOUR)
                end
            },
        },
        itemid = 17389
    },
	[BALL_SEAL_IDS.HEART_D] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_LOVE_HEART)
                        doSendMagicEffect(newPos, EFFECT_LOVE_HEARTS_FOUR)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_LOVE_HEART)
                        doSendMagicEffect(newPos, EFFECT_LOVE_HEARTS_FOUR)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_LOVE_HEART)
                        doSendMagicEffect(newPos, EFFECT_LOVE_HEARTS_FOUR)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_LOVE_HEART)
                        doSendMagicEffect(newPos, EFFECT_LOVE_HEARTS_FOUR)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_LOVE_HEART)
                        doSendMagicEffect(newPos, EFFECT_LOVE_HEARTS_FOUR)
                    end
                end
            },
            {
                interval = 1250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_LOVE_HEART)
                        doSendMagicEffect(newPos, EFFECT_LOVE_HEARTS_FOUR)
                    end
                end
            },
        },
        itemid = 17390
    },
	[BALL_SEAL_IDS.HEART_E] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_LOVE_HEART)
                        doSendMagicEffect(newPos, EFFECT_LOVE_HEARTS_TWO)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_LOVE_HEART)
                        doSendMagicEffect(newPos, EFFECT_LOVE_HEARTS_TWO)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_LOVE_HEART)
                        doSendMagicEffect(newPos, EFFECT_LOVE_HEARTS_TWO)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_LOVE_HEART)
                        doSendMagicEffect(newPos, EFFECT_LOVE_HEARTS_TWO)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_LOVE_HEART)
                        doSendMagicEffect(newPos, EFFECT_LOVE_HEARTS_TWO)
                    end
                end
            },
        },
        itemid = 17391
    },
	[BALL_SEAL_IDS.HEART_F] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.LOVE_HEART, doSendMagicEffect, EFFECT_LOVE_HEARTS_THREE)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.LOVE_HEART, doSendMagicEffect, EFFECT_LOVE_HEARTS_THREE)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.LOVE_HEART, doSendMagicEffect, EFFECT_LOVE_HEARTS_THREE)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.LOVE_HEART, doSendMagicEffect, EFFECT_LOVE_HEARTS_THREE)
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    executeInArea(position, AREAS.LOVE_HEART, doSendMagicEffect, EFFECT_LOVE_HEARTS_THREE)
                end
            }
        },
        itemid = 17392
    },
	[BALL_SEAL_IDS.STAR_A] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}, EFFECT_STAR_BUFF)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}, EFFECT_STAR_BUFF)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}, EFFECT_STAR_BUFF)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}, EFFECT_STAR_BUFF)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}, EFFECT_STAR_BUFF)
                    end
                end
            },
            {
                interval = 1250,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}, EFFECT_STAR_BUFF)
                    end
                end
            },
        },
        itemid = 17393
    },
	[BALL_SEAL_IDS.STAR_B] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_TELEPORT_TWO)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_TELEPORT_TWO)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE3X3_EMPTY, doSendMagicEffect, EFFECT_TELEPORT_TWO)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_TELEPORT_TWO)
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_TELEPORT_TWO)
                end
            },
        },
        itemid = 17394
    },
	[BALL_SEAL_IDS.STAR_C] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_GRAVEL)
                        doSendMagicEffect(newPos, EFFECT_YELLOW_TELEPORT_STAR)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_GRAVEL)
                        doSendMagicEffect(newPos, EFFECT_YELLOW_TELEPORT_STAR)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_GRAVEL)
                        doSendMagicEffect(newPos, EFFECT_YELLOW_TELEPORT_STAR)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_GRAVEL)
                        doSendMagicEffect(newPos, EFFECT_YELLOW_TELEPORT_STAR)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_GRAVEL)
                        doSendMagicEffect(newPos, EFFECT_YELLOW_TELEPORT_STAR)
                    end
                end
            },
        },
        itemid = 17395
    },
	[BALL_SEAL_IDS.STAR_D] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 3 do
                        doSendMagicEffect({x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}, EFFECT_POWER_UP)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 3 do
                        doSendMagicEffect({x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}, EFFECT_POWER_UP)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 3 do
                        doSendMagicEffect({x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}, EFFECT_POWER_UP)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 3 do
                        doSendMagicEffect({x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}, EFFECT_POWER_UP)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 3 do
                        doSendMagicEffect({x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}, EFFECT_POWER_UP)
                    end
                end
            },
            {
                interval = 1250,
                onExecute = function(position)
                    for i = 1, 3 do
                        doSendMagicEffect({x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}, EFFECT_POWER_UP)
                    end
                end
            },
        },
        itemid = 17396
    },
	[BALL_SEAL_IDS.STAR_E] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendMagicEffect(newPos, EFFECT_DOUBLE_SCRATCH)
                    end
                end
            },
            {
                interval = 150,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendMagicEffect(newPos, EFFECT_DOUBLE_SCRATCH)
                    end
                end
            },
            {
                interval = 300,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendMagicEffect(newPos, EFFECT_DOUBLE_SCRATCH)
                    end
                end
            },
            {
                interval = 450,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendMagicEffect(newPos, EFFECT_DOUBLE_SCRATCH)
                    end
                end
            },
            {
                interval = 600,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendMagicEffect(newPos, EFFECT_DOUBLE_SCRATCH)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendMagicEffect(newPos, EFFECT_DOUBLE_SCRATCH)
                    end
                end
            },
            {
                interval = 900,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendMagicEffect(newPos, EFFECT_DOUBLE_SCRATCH)
                    end
                end
            },
        },
        itemid = 17397
    },
	[BALL_SEAL_IDS.STAR_F] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}
                        doSendMagicEffect(newPos, EFFECT_FAILING_STARS)
                    end
                end
            },
            {
                interval = 300,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}
                        doSendMagicEffect(newPos, EFFECT_FAILING_STARS)
                    end
                end
            },
            {
                interval = 600,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}
                        doSendMagicEffect(newPos, EFFECT_FAILING_STARS)
                    end
                end
            },
            {
                interval = 900,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}
                        doSendMagicEffect(newPos, EFFECT_FAILING_STARS)
                    end
                end
            },
            {
                interval = 1200,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}
                        doSendMagicEffect(newPos, EFFECT_FAILING_STARS)
                    end
                end
            },
        },
        itemid = 17398
    },
	[BALL_SEAL_IDS.LINE_A] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE1, doSendMagicEffect, EFFECT_BUBBLES)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE2, doSendMagicEffect, EFFECT_BUBBLES)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE3, doSendMagicEffect, EFFECT_BUBBLES)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE4, doSendMagicEffect, EFFECT_BUBBLES)
                end
            },
        },
        itemid = 17399
    },
	[BALL_SEAL_IDS.LINE_B] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE1, doSendMagicEffect, EFFECT_FIRE)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE2, doSendMagicEffect, EFFECT_FIRE)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE3, doSendMagicEffect, EFFECT_FIRE)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE4, doSendMagicEffect, EFFECT_FIRE)
                end
            },
        },
        itemid = 17400
    },
	[BALL_SEAL_IDS.LINE_C] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE1, doSendMagicEffect, EFFECT_LEAVES)
                    executeInArea(position, AREAS.LINE1, doSendMagicEffect, EFFECT_LEAVES_TWO)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE2, doSendMagicEffect, EFFECT_LEAVES)
                    executeInArea(position, AREAS.LINE2, doSendMagicEffect, EFFECT_LEAVES_TWO)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE3, doSendMagicEffect, EFFECT_LEAVES)
                    executeInArea(position, AREAS.LINE3, doSendMagicEffect, EFFECT_LEAVES_TWO)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE4, doSendMagicEffect, EFFECT_LEAVES)
                    executeInArea(position, AREAS.LINE4, doSendMagicEffect, EFFECT_LEAVES_TWO)
                end
            },
        },
        itemid = 17401
    },
	[BALL_SEAL_IDS.LINE_D] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE1, doSendMagicEffect, EFFECT_ELECTRIC_BALL_FOUR)
                    executeInArea(position, AREAS.LINE1, doSendMagicEffect, EFFECT_ELECTRIC_CLOUD)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE2, doSendMagicEffect, EFFECT_ELECTRIC_BALL_FOUR)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE3, doSendMagicEffect, EFFECT_ELECTRIC_BALL_FOUR)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE4, doSendMagicEffect, EFFECT_ELECTRIC_BALL_FOUR)
                end
            },
        },
        itemid = 17402
    },
	[BALL_SEAL_IDS.SMOKE_A] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_POISON_BLAST)
                        doSendMagicEffect(newPos, EFFECT_POISON_GAS_THREE)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_POISON_BLAST)
                        doSendMagicEffect(newPos, EFFECT_POISON_GAS_THREE)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_POISON_BLAST)
                        doSendMagicEffect(newPos, EFFECT_POISON_GAS_THREE)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_POISON_BLAST)
                        doSendMagicEffect(newPos, EFFECT_POISON_GAS_THREE)
                    end
                end
            },
        },
        itemid = 17403
    },
	[BALL_SEAL_IDS.SMOKE_B] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_POISON_BLAST)
                        doSendMagicEffect(newPos, EFFECT_POISON_GAS_TWO)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_POISON_BLAST)
                        doSendMagicEffect(newPos, EFFECT_POISON_GAS_TWO)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_POISON_BLAST)
                        doSendMagicEffect(newPos, EFFECT_POISON_GAS_TWO)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_POISON_BLAST)
                        doSendMagicEffect(newPos, EFFECT_POISON_GAS_TWO)
                    end
                end
            },
        },
        itemid = 17404
    },
	[BALL_SEAL_IDS.SMOKE_C] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_POISON_GAS_THREE)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_POISON_GAS_THREE)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE3X3_EMPTY, doSendMagicEffect, EFFECT_POISON_GAS_THREE)
                end
            }
        },
        itemid = 17405
    },
	[BALL_SEAL_IDS.SMOKE_D] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_SLUDGE)
                        doSendMagicEffect(newPos, EFFECT_PINK_MINICLOUD)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_SLUDGE)
                        doSendMagicEffect(newPos, EFFECT_PINK_MINICLOUD)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_SLUDGE)
                        doSendMagicEffect(newPos, EFFECT_PINK_MINICLOUD)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_SLUDGE)
                        doSendMagicEffect(newPos, EFFECT_PINK_MINICLOUD)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_SLUDGE)
                        doSendMagicEffect(newPos, EFFECT_PINK_MINICLOUD)
                    end
                end
            },
            {
                interval = 1250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_SLUDGE)
                        doSendMagicEffect(newPos, EFFECT_PINK_MINICLOUD)
                    end
                end
            },
        },
        itemid = 17406
    },
	[BALL_SEAL_IDS.ELE_A] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_THUNDER)
                        doSendMagicEffect(newPos, EFFECT_THUNDER)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_THUNDER)
                        doSendMagicEffect(newPos, EFFECT_THUNDER)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_THUNDER)
                        doSendMagicEffect(newPos, EFFECT_THUNDER)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_THUNDER)
                        doSendMagicEffect(newPos, EFFECT_THUNDER)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_THUNDER)
                        doSendMagicEffect(newPos, EFFECT_THUNDER)
                    end
                end
            },
        },
        itemid = 17407
    },
	[BALL_SEAL_IDS.ELE_B] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_ELECTRIC_BALL)
                        doSendMagicEffect(newPos, EFFECT_ELECTRIC_SPARK)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_ELECTRIC_BALL)
                        doSendMagicEffect(newPos, EFFECT_ELECTRIC_SPARK)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_ELECTRIC_BALL)
                        doSendMagicEffect(newPos, EFFECT_ELECTRIC_SPARK)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_ELECTRIC_BALL)
                        doSendMagicEffect(newPos, EFFECT_ELECTRIC_SPARK)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 3 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_ELECTRIC_BALL)
                        doSendMagicEffect(newPos, EFFECT_ELECTRIC_SPARK)
                    end
                end
            },
        },
        itemid = 17408
    },
	[BALL_SEAL_IDS.ELE_C] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE1, doSendMagicEffect, EFFECT_ELECTRIC_SPARK)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE2, doSendMagicEffect, EFFECT_ELECTRIC_SPARK)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE3, doSendMagicEffect, EFFECT_ELECTRIC_SPARK)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE4, doSendMagicEffect, EFFECT_ELECTRIC_SPARK)
                    executeInArea(position, AREAS.LINE4, doSendMagicEffect, EFFECT_ELECTRIC_CLOUD)
                end
            },
        },
        itemid = 17409
    },
	[BALL_SEAL_IDS.ELE_D] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_ELECTRIC_BALL)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_ELECTRIC_SPARK_TWO)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE3X3_EMPTY, doSendMagicEffect, EFFECT_ELECTRIC_SPARK_TWO)
                end
            },
        },
        itemid = 17410
    },
	[BALL_SEAL_IDS.FOAMY_A] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_BUBBLE)
                        doSendMagicEffect(newPos, EFFECT_BUBBLES)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_BUBBLE)
                        doSendMagicEffect(newPos, EFFECT_BUBBLES)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_BUBBLE)
                        doSendMagicEffect(newPos, EFFECT_BUBBLES)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_BUBBLE)
                        doSendMagicEffect(newPos, EFFECT_BUBBLES)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_BUBBLE)
                        doSendMagicEffect(newPos, EFFECT_BUBBLES)
                    end
                end
            },
        },
        itemid = 17411
    },
	[BALL_SEAL_IDS.FOAMY_B] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_BUBBLES_TWO)
                        doSendMagicEffect(newPos, EFFECT_SPLASH)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_BUBBLES_TWO)
                        doSendMagicEffect(newPos, EFFECT_SPLASH)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_BUBBLES_TWO)
                        doSendMagicEffect(newPos, EFFECT_SPLASH)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_BUBBLES_TWO)
                        doSendMagicEffect(newPos, EFFECT_SPLASH)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_BUBBLES_TWO)
                        doSendMagicEffect(newPos, EFFECT_SPLASH)
                    end
                end
            },
        },
        itemid = 17412
    },
	[BALL_SEAL_IDS.FOAMY_C] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE1, doSendMagicEffect, EFFECT_WATER_PULSE_TWO)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE1, doSendMagicEffect, EFFECT_WATER_PULSE_TWO)
                    executeInArea(position, AREAS.LINE2, doSendMagicEffect, EFFECT_WATER_PULSE_TWO)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE1, doSendMagicEffect, EFFECT_WATER_PULSE_TWO)
                    executeInArea(position, AREAS.LINE2, doSendMagicEffect, EFFECT_WATER_PULSE_TWO)
                    executeInArea(position, AREAS.LINE3, doSendMagicEffect, EFFECT_WATER_PULSE_TWO)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE1, doSendMagicEffect, EFFECT_WATER_PULSE_TWO)
                    executeInArea(position, AREAS.LINE2, doSendMagicEffect, EFFECT_WATER_PULSE_TWO)
                    executeInArea(position, AREAS.LINE3, doSendMagicEffect, EFFECT_WATER_PULSE_TWO)
                    executeInArea(position, AREAS.LINE4, doSendMagicEffect, EFFECT_WATER_PULSE_TWO)
                end
            },
        },
        itemid = 17413
    },
	[BALL_SEAL_IDS.FOAMY_D] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_WATER_BALL)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_WATER_DISAPPEAR)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE3X3_EMPTY, doSendMagicEffect, EFFECT_WATER_DISAPPEAR)
                end
            },
        },
        itemid = 17414
    },
	[BALL_SEAL_IDS.FIRE_A] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_FIRE)
                        doSendMagicEffect(newPos, EFFECT_FIRE)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_FIRE)
                        doSendMagicEffect(newPos, EFFECT_BIG_FLAMES)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_FIRE)
                        doSendMagicEffect(newPos, EFFECT_FIRE)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_FIRE)
                        doSendMagicEffect(newPos, EFFECT_FIRE)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_FIRE)
                        doSendMagicEffect(newPos, EFFECT_BIG_FLAMES)
                    end
                end
            },
        },
        itemid = 17415
    },
	[BALL_SEAL_IDS.FIRE_B] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_FIRE)
                        doSendMagicEffect(newPos, EFFECT_FIRE_FIELD)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_FIRE)
                        doSendMagicEffect(newPos, EFFECT_FIRE_FIELD)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_FIRE)
                        doSendMagicEffect(newPos, EFFECT_FIRE_FIELD)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_FIRE)
                        doSendMagicEffect(newPos, EFFECT_FIRE_FIELD)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_FIRE)
                        doSendMagicEffect(newPos, EFFECT_FIRE_FIELD)
                    end
                end
            },
        },
        itemid = 17416
    },
	[BALL_SEAL_IDS.FIRE_C] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE1, doSendMagicEffect, EFFECT_FIRE)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE2, doSendMagicEffect, EFFECT_FIRE)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE3, doSendMagicEffect, EFFECT_FIRE)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE4, doSendMagicEffect, EFFECT_BIG_FLAMES)
                end
            },
        },
        itemid = 17417
    },
	[BALL_SEAL_IDS.FIRE_D] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_FIRE)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_BIG_FLAMES)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE3X3_EMPTY, doSendMagicEffect, EFFECT_BIG_FLAMES)
                end
            },
        },
        itemid = 17418
    },
	[BALL_SEAL_IDS.PARTY_A] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_FIREWORK_BLUE)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_FIREWORK_BLUE)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_FIREWORK_BLUE)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_FIREWORK_BLUE)
                end
            },
        },
        itemid = 17419
    },
	[BALL_SEAL_IDS.PARTY_B] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_FIREWORK_RED)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_FIREWORK_RED)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_FIREWORK_RED)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_FIREWORK_RED)
                end
            },
        },
        itemid = 17420
    },
	[BALL_SEAL_IDS.PARTY_C] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_FIREWORK_YELLOW)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_FIREWORK_YELLOW)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_FIREWORK_YELLOW)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_FIREWORK_YELLOW)
                end
            },
        },
        itemid = 17421
    },
	[BALL_SEAL_IDS.PARTY_D] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}, table.random({EFFECT_FIREWORK_BLUE, EFFECT_FIREWORK_RED, EFFECT_FIREWORK_YELLOW}))
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}, table.random({EFFECT_FIREWORK_BLUE, EFFECT_FIREWORK_RED, EFFECT_FIREWORK_YELLOW}))
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}, table.random({EFFECT_FIREWORK_BLUE, EFFECT_FIREWORK_RED, EFFECT_FIREWORK_YELLOW}))
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}, table.random({EFFECT_FIREWORK_BLUE, EFFECT_FIREWORK_RED, EFFECT_FIREWORK_YELLOW}))
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-2, 2), y = position.y + getRandom(-2, 2),
                            z = position.z}, table.random({EFFECT_FIREWORK_BLUE, EFFECT_FIREWORK_RED, EFFECT_FIREWORK_YELLOW}))
                    end
                end
            },
        },
        itemid = 17422
    },
	[BALL_SEAL_IDS.FLORA_A] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_LEAF)
                        doSendMagicEffect(newPos, EFFECT_ROOTS)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_LEAF)
                        doSendMagicEffect(newPos, EFFECT_ROOTS_TWO)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_LEAF)
                        doSendMagicEffect(newPos, EFFECT_ROOTS)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_LEAF)
                        doSendMagicEffect(newPos, EFFECT_ROOTS_TWO)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_LEAF)
                        doSendMagicEffect(newPos, EFFECT_ROOTS)
                    end
                end
            },
        },
        itemid = 17423
    },
	[BALL_SEAL_IDS.FLORA_B] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_LEAF)
                        doSendMagicEffect(newPos, EFFECT_GREEN_FALLS)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_LEAF)
                        doSendMagicEffect(newPos, EFFECT_GREEN_FALLS)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_LEAF)
                        doSendMagicEffect(newPos, EFFECT_GREEN_FALLS)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_LEAF)
                        doSendMagicEffect(newPos, EFFECT_GREEN_FALLS)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_LEAF)
                        doSendMagicEffect(newPos, EFFECT_GREEN_FALLS)
                    end
                end
            },
        },
        itemid = 17424
    },
	[BALL_SEAL_IDS.FLORA_C] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE1, doSendMagicEffect, EFFECT_GREEN_FALLS)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE2, doSendMagicEffect, EFFECT_GREEN_FALLS)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE3, doSendMagicEffect, EFFECT_GREEN_FALLS)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.LINE4, doSendMagicEffect, EFFECT_ROOTS_FOUR)
                end
            },
        },
        itemid = 17425
    },
	[BALL_SEAL_IDS.FLORA_D] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_ROOTS)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_ROOTS_TWO)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE3X3_EMPTY, doSendMagicEffect, EFFECT_ROOTS_THREE)
                end
            },
        },
        itemid = 17426
    },
	[BALL_SEAL_IDS.FLORA_E] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_COLORED_LEAVES)
                        doSendMagicEffect(newPos, EFFECT_YELLOW_FALLS)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_COLORED_LEAVES)
                        doSendMagicEffect(newPos, EFFECT_PURPLE_POWDER)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_COLORED_LEAVES)
                        doSendMagicEffect(newPos, EFFECT_GREEN_FALLS)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_COLORED_LEAVES)
                        doSendMagicEffect(newPos, EFFECT_PURPLE_POWDER)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_COLORED_LEAVES)
                        doSendMagicEffect(newPos, EFFECT_GREEN_FALLS)
                    end
                end
            },
            {
                interval = 1250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}
                        doSendDistanceShoot(getSkyPosition(newPos), newPos, PROJECTILE_COLORED_LEAVES)
                        doSendMagicEffect(newPos, EFFECT_PURPLE_POWDER)
                    end
                end
            },
        },
        itemid = 17427
    },
	[BALL_SEAL_IDS.FLORA_F] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_LEAF)
                        doSendMagicEffect(newPos, EFFECT_LEAVES)
                        doSendMagicEffect(newPos, EFFECT_LEAVES_TWO)
                    end
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_LEAF)
                        doSendMagicEffect(newPos, EFFECT_LEAVES)
                        doSendMagicEffect(newPos, EFFECT_LEAVES_TWO)
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_LEAF)
                        doSendMagicEffect(newPos, EFFECT_LEAVES)
                        doSendMagicEffect(newPos, EFFECT_LEAVES_TWO)
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_LEAF)
                        doSendMagicEffect(newPos, EFFECT_LEAVES)
                        doSendMagicEffect(newPos, EFFECT_LEAVES_TWO)
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        local newPos = {x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3), z = position.z}
                        doSendDistanceShoot(position, newPos, PROJECTILE_LEAF)
                        doSendMagicEffect(newPos, EFFECT_LEAVES)
                        doSendMagicEffect(newPos, EFFECT_LEAVES_TWO)
                    end
                end
            },
        },
        itemid = 17428
    },
	[BALL_SEAL_IDS.SONG_A] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_BLUE_SOUND)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_FIREWORK_BLUE)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_BLUE_SOUND)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_BLUE_SOUND)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_BLUE_SOUND)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_FIREWORK_BLUE)
                end
            },
        },
        itemid = 17429
    },
	[BALL_SEAL_IDS.SONG_B] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_PURPLE_SOUND)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_FIREWORK_BLUE)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_PURPLE_SOUND)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_PURPLE_SOUND)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_PURPLE_SOUND)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_FIREWORK_BLUE)
                end
            },
        },
        itemid = 17430
    },
	[BALL_SEAL_IDS.SONG_C] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_YELLOW_SOUND)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_FIREWORK_YELLOW)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_YELLOW_SOUND)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_YELLOW_SOUND)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_YELLOW_SOUND)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_FIREWORK_YELLOW)
                end
            },
        },
        itemid = 17431
    },
	[BALL_SEAL_IDS.SONG_D] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_RED_SOUND)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_FIREWORK_RED)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_RED_SOUND)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_RED_SOUND)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_RED_SOUND)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_FIREWORK_RED)
                end
            },
        },
        itemid = 17432
    },
	[BALL_SEAL_IDS.SONG_E] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_GREEN_SOUND)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_GREEN_FALLS)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_GREEN_SOUND)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_GREEN_SOUND)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_GREEN_SOUND)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_GREEN_FALLS)
                end
            },
        },
        itemid = 17433
    },
	[BALL_SEAL_IDS.SONG_F] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_PURPLE_SOUND)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_PURPLE_POWDER)
                end
            },
            {
                interval = 250,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_PURPLE_SOUND)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_PURPLE_SOUND)
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_PURPLE_SOUND)
                    executeInArea(position, AREAS.CIRCLE2X2_EMPTY, doSendMagicEffect, EFFECT_PURPLE_POWDER)
                end
            },
        },
        itemid = 17434
    },
	[BALL_SEAL_IDS.SONG_G] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}, table.random({EFFECT_BLUE_SOUND, EFFECT_RED_SOUND, EFFECT_YELLOW_SOUND}))
                    end
                end
            },
            {
                interval = 100,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}, table.random({EFFECT_FIREWORK_BLUE, EFFECT_FIREWORK_RED, EFFECT_FIREWORK_YELLOW}))
                    end
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}, table.random({EFFECT_BLUE_SOUND, EFFECT_RED_SOUND, EFFECT_YELLOW_SOUND}))
                    end
                end
            },
            {
                interval = 750,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}, table.random({EFFECT_FIREWORK_BLUE, EFFECT_FIREWORK_RED, EFFECT_FIREWORK_YELLOW}))
                    end
                end
            },
            {
                interval = 1000,
                onExecute = function(position)
                    for i = 1, 10 do
                        doSendMagicEffect({x = position.x + getRandom(-3, 3), y = position.y + getRandom(-3, 3),
                            z = position.z}, table.random({EFFECT_BLUE_SOUND, EFFECT_RED_SOUND, EFFECT_YELLOW_SOUND}))
                    end
                end
            },
        },
        itemid = 17435
    },
	[BALL_SEAL_IDS.BURST] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE1, doSendMagicEffect, EFFECT_FIRE)
                end
            },
            {
                interval = 100,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE2, doSendMagicEffect, EFFECT_FIRE)
                end
            },
            {
                interval = 200,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE3, doSendMagicEffect, EFFECT_FIRE)
                end
            },
            {
                interval = 300,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE4, doSendMagicEffect, EFFECT_FIRE)
                end
            },
            {
                interval = 400,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE5, doSendMagicEffect, EFFECT_FIRE)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE6, doSendMagicEffect, EFFECT_FIRE)
                end
            },
            {
                interval = 600,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE7, doSendMagicEffect, EFFECT_FIRE)
                end
            },
            {
                interval = 700,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE8, doSendMagicEffect, EFFECT_FIRE)
                end
            },
            {
                interval = 900,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_BIG_FLAMES)
                end
            },
        },
        itemid = 17436
    },
	[BALL_SEAL_IDS.LIQUID] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE1, doSendMagicEffect, EFFECT_BUBBLES)
                end
            },
            {
                interval = 100,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE2, doSendMagicEffect, EFFECT_BUBBLES)
                end
            },
            {
                interval = 200,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE3, doSendMagicEffect, EFFECT_BUBBLES)
                end
            },
            {
                interval = 300,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE4, doSendMagicEffect, EFFECT_BUBBLES)
                end
            },
            {
                interval = 400,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE5, doSendMagicEffect, EFFECT_BUBBLES)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE6, doSendMagicEffect, EFFECT_BUBBLES)
                end
            },
            {
                interval = 600,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE7, doSendMagicEffect, EFFECT_BUBBLES)
                end
            },
            {
                interval = 700,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE8, doSendMagicEffect, EFFECT_BUBBLES)
                end
            },
            {
                interval = 2900,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_BIG_BUBBLE)
                end
            },
        },
        itemid = 17437
    },
	[BALL_SEAL_IDS.TWINKLE] = {
        frames = {
            {
                interval = 0,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE1, doSendMagicEffect, EFFECT_ELECTRIC_SPARK_TWO)
                end
            },
            {
                interval = 100,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE2, doSendMagicEffect, EFFECT_ELECTRIC_SPARK_TWO)
                end
            },
            {
                interval = 200,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE3, doSendMagicEffect, EFFECT_ELECTRIC_SPARK_TWO)
                end
            },
            {
                interval = 300,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE4, doSendMagicEffect, EFFECT_ELECTRIC_SPARK_TWO)
                end
            },
            {
                interval = 400,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE5, doSendMagicEffect, EFFECT_ELECTRIC_SPARK_TWO)
                end
            },
            {
                interval = 500,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE6, doSendMagicEffect, EFFECT_ELECTRIC_SPARK_TWO)
                end
            },
            {
                interval = 600,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE7, doSendMagicEffect, EFFECT_ELECTRIC_SPARK_TWO)
                end
            },
            {
                interval = 700,
                onExecute = function(position)
                    executeInArea(position, AREAS.CLOCKWISE8, doSendMagicEffect, EFFECT_ELECTRIC_SPARK_TWO)
                end
            },
            {
                interval = 900,
                onExecute = function(position)
                    executeInArea(position, AREAS.SQUARE1X1, doSendMagicEffect, EFFECT_THUNDER_CLOUD)
                end
            },
        },
        itemid = 17438
    },
}

-- Auto generate Seals by itemid
local SEAL_BY_ITEMID = {}
for id, content in pairs(BALL_SEALS) do
    SEAL_BY_ITEMID[content.itemid] = id
end

function getBallSealItemid(seal)
    return BALL_SEALS[seal].itemid
end

function doBallSealAnimationStart(ballSealId, position)
    for _, frame in pairs(BALL_SEALS[ballSealId].frames) do
        if (frame.interval > 0) then
            addEvent(frame.onExecute, frame.interval, position)
        else
            frame.onExecute(position)
        end
    end
end

local ATTRIBUTE_FROM_NPC = 5000

function setSealFromNpc(uid, value)
    doItemSetAttribute(uid, ATTRIBUTE_FROM_NPC, value and 1 or 0)
end

function getSealFromNpc(uid)
    local r = getItemAttribute(uid, ATTRIBUTE_FROM_NPC)
    return r and tonumber(r) > 0
end

--[[
-- Ball Seal
]]
function onCreatureUseBallSeal(cid, item, fromPosition, itemEx, toPosition)
    local seal = SEAL_BY_ITEMID[item.itemid]
    if (not seal) then
        log(LOG_TYPES.ERROR, "Unknown seal", getCreatureName(cid), item.itemid)
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false

    elseif (not isItem(itemEx) or not isBallWithPokemon(itemEx.uid)) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false

    elseif (isPokemonOnline(cid)) then
        doPlayerSendCancel(cid, "You can not do it while you have a Pokemon out of the ball.")
        return false

    elseif (fromPosition.x ~= CONTAINER_POSITION or toPosition.x ~= CONTAINER_POSITION) then -- TODO: This doesnt mean that the player is carring the item or no
        doPlayerSendCancel(cid, "You must pick up this item first.")
        return false

    elseif (getBallSeal(itemEx.uid) ~= BALL_SEAL_IDS.NONE) then
        doPlayerSendCancel(cid, "Before attach a new seal, you must remove the current.")
        return false

    elseif (getSealFromNpc(item.uid) ~= getBallFromNpc(itemEx.uid)) then
        doPlayerSendCancel(cid, "You can not attach this seal into this Poke Ball.")
        return false
    end

    setBallSeal(itemEx.uid, seal)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_FIREWORK_RED)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "Congratulations! Your %s ball received the %s successfuly!"), ballsNames[itemEx.itemid], getItemNameById(item.itemid)))
    doBallUpdateDescription(itemEx.uid)
    doRemoveItem(item.uid)
    return true
end

--[[
-- Ball Seal Remover
]]
function onCreatureUseBallSealRemover(cid, item, fromPosition, itemEx, toPosition)
    if (not isItem(itemEx) or not isBallWithPokemon(itemEx.uid) or getBallSeal(itemEx.uid) == BALL_SEAL_IDS.NONE) then
        doPlayerSendDefaultCancel(cid, RETURNVALUE_NOTPOSSIBLE)
        return false

    elseif (isPokemonOnline(cid)) then
        doPlayerSendCancel(cid, "You can not do it while you have a Pokemon out of the ball.")
        return false

    elseif (fromPosition.x ~= CONTAINER_POSITION or toPosition.x ~= CONTAINER_POSITION) then -- TODO: This doesnt mean that the player is carring the item or no
        doPlayerSendCancel(cid, "You must pick up this item first.")
        return false

    elseif (getBallFromNpc(itemEx.uid)) then
        doPlayerSendCancel(cid, "You cannot detach a seal from a NPC Pokemon.")
        return false
    end

    local seal = getBallSeal(itemEx.uid)

    setBallSeal(itemEx.uid, BALL_SEAL_IDS.NONE)
    doSendMagicEffect(getCreaturePosition(cid), EFFECT_POFF)
    doPlayerSendTextMessage(cid, MESSAGE_STATUS_CONSOLE_BLUE, string.format(__L(cid, "You removed your %s ball seal successfuly!"), ballsNames[itemEx.itemid]))
    doBallUpdateDescription(itemEx.uid)
    doRemoveItem(item.uid, 1)
    doPlayerAddItem(cid, getBallSealItemid(seal), 1, true)
    return true
end