-- Constants
local DOLL_STATUS_EMPTY = -1
local DOLL_STATUS_OWN = 1

local DOLL_ITEMID_BY_POKEMON_NUMBER = {
    [1] = 11232,
    [2] = 16417,
    [3] = 16418,
    [4] = 16419,
    [5] = 16420,
    [6] = 16421,
    [7] = 16422,
    [8] = 16423,
    [9] = 16424,
    [10] = 16425,
    [11] = 16426,
    [12] = 16427,
    [13] = 16428,
    [14] = 16429,
    [15] = 16430,
    [16] = 16431,
    [17] = 16432,
    [18] = 11214,
    [19] = 16433,
    [20] = 16434,
    [21] = 16435,
    [22] = 16436,
    [23] = 16437,
    [24] = 16438,
    [25] = 11217,
    [26] = 11233,
    [27] = 16439,
    [28] = 16440,
    [29] = 16441,
    [30] = 16442,
    [31] = 16443,
    [32] = 16444,
    [33] = 16445,
    [34] = 16446,
    [35] = 16447,
    [36] = 16448,
    [37] = 16449,
    [38] = 16450,
    [39] = 11231,
    [40] = 16451,
    [41] = 16452,
    [42] = 16453,
    [43] = 16454,
    [44] = 16455,
    [45] = 16456,
    [46] = 16457,
    [47] = 16458,
    [48] = 16459,
    [49] = 16460,
    [50] = 16461,
    [51] = 16462,
    [52] = 16463,
    [53] = 16464,
    [54] = 11224,
    [55] = 16465,
    [56] = 16466,
    [57] = 16467,
    [58] = 16468,
    [59] = 16469,
    [60] = 16470,
    [61] = 16471,
    [62] = 11216,
    [63] = 16472,
    [64] = 16473,
    [65] = 16474,
    [66] = 16475,
    [67] = 16476,
    [68] = 16477,
    [69] = 16478,
    [70] = 16479,
    [71] = 16480,
    [72] = 16481,
    [73] = 16482,
    [74] = 16483,
    [75] = 16484,
    [76] = 16485,
    [77] = 16486,
    [78] = 16487,
    [79] = 16488,
    [80] = 11227,
    [81] = 16489,
    [82] = 16490,
    [83] = 16491,
    [84] = 16492,
    [85] = 16493,
    [86] = 11218,
    [87] = 16494,
    [88] = 16495,
    [89] = 16496,
    [90] = 16497,
    [91] = 16498,
    [92] = 16499,
    [93] = 16500,
    [94] = 16501,
    [95] = 16502,
    [96] = 16503,
    [97] = 16504,
    [98] = 16505,
    [99] = 16506,
    [100] = 16507,
    [101] = 16508,
    [102] = 16509,
    [103] = 16510,
    [104] = 11230,
    [105] = 16511,
    [106] = 16512,
    [107] = 16513,
    [108] = 16514,
    [109] = 16515,
    [110] = 16516,
    [111] = 16517,
    [112] = 16518,
    [113] = 11229,
    [114] = 16519,
    [115] = 16520,
    [116] = 16521,
    [117] = 16522,
    [118] = 16523,
    [119] = 16524,
    [120] = 16525,
    [121] = 16526,
    [122] = 16527,
    [123] = 16528,
    [124] = 16529,
    [125] = 16530,
    [126] = 16531,
    [127] = 16532,
    [128] = 16533,
    [129] = 16534,
    [130] = 16535,
    [131] = 11219,
    [132] = 16536,
    [133] = 16537,
    [134] = 16538,
    [135] = 16539,
    [136] = 16540,
    [137] = 16541,
    [138] = 11228,
    [139] = 16542,
    [140] = 11226,
    [141] = 16543,
    [142] = 16544,
    [143] = 16545,
    [144] = 11221,
    [145] = 11222,
    [146] = 11223,
    [147] = 16546,
    [148] = 16547,
    [149] = 16548,
    [150] = 11225,
    [151] = 11215,
    [152] = 16549,
    [153] = 16550,
    [154] = 16551,
    [155] = 16552,
    [156] = 16553,
    [157] = 16554,
    [158] = 16555,
    [159] = 16556,
    [160] = 16557,
    [161] = 16558,
    [162] = 16559,
    [163] = 16560,
    [164] = 16561,
    [165] = 16562,
    [166] = 16563,
    [167] = 16564,
    [168] = 16565,
    [169] = 16566,
    [170] = 16567,
    [171] = 16568,
    [172] = 16569,
    [173] = 16570,
    [174] = 16571,
    [175] = 16572,
    [176] = 16573,
    [177] = 16574,
    [178] = 16575,
    [179] = 16576,
    [180] = 16577,
    [181] = 16578,
    [182] = 16579,
    [183] = 16580,
    [184] = 16581,
    [185] = 16582,
    [186] = 16583,
    [187] = 16584,
    [188] = 16585,
    [189] = 16586,
    [190] = 16587,
    [191] = 16588,
    [192] = 16589,
    [193] = 16590,
    [194] = 16591,
    [195] = 16592,
    [196] = 16593,
    [197] = 16594,
    [198] = 16595,
    [199] = 16596,
    [200] = 16597,
    [202] = 16598,
    [203] = 16599,
    [204] = 16600,
    [205] = 16601,
    [206] = 16602,
    [207] = 16603,
    [208] = 16604,
    [209] = 16605,
    [210] = 16606,
    [211] = 16607,
    [212] = 16608,
    [213] = 16609,
    [214] = 16610,
    [215] = 16611,
    [216] = 16612,
    [217] = 16613,
    [218] = 16614,
    [219] = 16615,
    [220] = 16616,
    [221] = 16617,
    [222] = 16618,
    [223] = 16619,
    [224] = 16620,
    [225] = 16621,
    [226] = 16622,
    [227] = 16623,
    [228] = 16624,
    [229] = 16625,
    [230] = 16626,
    [231] = 16627,
    [232] = 16628,
    [233] = 16629,
    [234] = 16630,
    [235] = 16631,
    [236] = 16632,
    [237] = 16633,
    [238] = 16634,
    [239] = 16635,
    [240] = 16636,
    [241] = 16637,
    [242] = 16638,
    [243] = 16639,
    [244] = 16640,
    [245] = 16641,
    [246] = 16642,
    [247] = 16643,
    [248] = 16644,
    [249] = 11220,
    [250] = 16645,
    [251] = 16646,
}

-- Vars
local dollCaseWindow, panel, dolls

-- Methods
local function hide()
    dollCaseWindow:hide()
end

local function show()
    dollCaseWindow:show()
end

local function reset()
    panel:destroyChildren()
    dolls = {}
end

-- Hooks
function onStatus(status)
    reset()

    for k, v in pairs(status) do
        if (k > 200) then
            k = k + 1 -- ugly fix for unown doll skipping
        end

        local item = g_ui.createWidget('DollStatusItem', panel)
        item:setId(k)
        item:setMargin(0)
        item:setItemId(DOLL_ITEMID_BY_POKEMON_NUMBER[k])
        if (v ~= DOLL_STATUS_OWN) then
            item:setColor('#00000099')
        end
        dolls[k] = item
    end

    show()
end

function onDollUpdate(pokemonNumber, status)
    if (dolls[pokemonNumber]) then
        dolls[pokemonNumber]:setColor(status ~= DOLL_STATUS_OWN and '#00000099' or '#FFFFFFFF')
    end
end

function onOnline()
    reset()

    dollCaseWindow:getChildById('icon'):setItemId(22120)
end

function onOffline()
    hide()
    reset()
end

function onInit()
    g_ui.importStyle('dollcase')

    dollCaseWindow = g_ui.createWidget('DollCaseWindow', modules.game_interface.getRootPanel())
    dollCaseWindow:setup()
    dollCaseWindow:setPosition({
        x = (g_window.getDisplaySize().width - dollCaseWindow:getWidth()) / 2,
        y = (g_window.getDisplaySize().height - dollCaseWindow:getHeight()) / 2})
    dollCaseWindow:setVisible(false)
    dollCaseWindow:setDroppable(false)

    panel = dollCaseWindow:recursiveGetChildById('ownDexContainer')

    connect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onDollCaseStatus = onStatus,
        onDollCaseUpdate = onDollUpdate
    })

    if (g_game.isOnline()) then
        onOnline()
    end
end

function onTerminate()
    disconnect(g_game, {
        onGameStart = onOnline,
        onGameEnd = onOffline,
        onDollCaseStatus = onStatus,
        onDollCaseUpdate = onDollUpdate
    })

    reset()
    dollCaseWindow:destroyChildren()
    dollCaseWindow:destroy()
end