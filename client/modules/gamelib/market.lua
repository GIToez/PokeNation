MarketAction = {
  Buy = 0,
  Sell = 1
}

MarketRequest = {
  MyOffers = 0xFFFE,
  MyHistory = 0xFFFF
}

MarketOfferState = {
  Active = 0,
  Cancelled = 1,
  Expired = 2,
  Accepted = 3,
  AcceptedEx = 255
}

MarketCategory = {
  All = 0,
  Products = 1,
  Foods = 2,
  Valuables = 3,
  Potions = 4,
  Dolls = 5,
  Containers = 6,
  Berries = 7,
  PaintTickets = 8,
  TechnicalMachines = 9,
  Seals = 10,
  Decoration = 11,
  Evolutionaries = 12
}

MarketCategory.First = MarketCategory.All
MarketCategory.Last = MarketCategory.Evolutionaries

MarketCategoryWeapons = {
  --[[[MarketCategory.Ammunition] = { slots = {255} },
  [MarketCategory.Axes] = { slots = {255, InventorySlotOther, InventorySlotLeft} },
  [MarketCategory.Clubs] = { slots = {255, InventorySlotOther, InventorySlotLeft} },
  [MarketCategory.DistanceWeapons] = { slots = {255, InventorySlotOther, InventorySlotLeft} },
  [MarketCategory.Swords] = { slots = {255, InventorySlotOther, InventorySlotLeft} },
  [MarketCategory.WandsRods] = { slots = {255, InventorySlotOther, InventorySlotLeft} }]]
}

MarketCategoryStrings = {
  [0] = 'All',
  [1] = 'Products',
  [2] = 'Foods',
  [3] = 'Valuables',
  [4] = 'Potions',
  [5] = 'Dolls',
  [6] = 'Containers',
  [7] = 'Berries',
  [8] = 'Paint Tickets',
  [9] = 'Technical Machines',
  [10] = 'Seals',
  [11] = 'Decoration',
  [12] = 'Evolutionaries',
}

function getMarketCategoryName(id)
  if table.haskey(MarketCategoryStrings, id) then
    return MarketCategoryStrings[id]
  end
end

function getMarketCategoryId(name)
  local id = table.find(MarketCategoryStrings, name)
  if id then
    return id
  end
end

MarketItemDescription = {
  Armor = 1,
  Attack = 2,
  Container = 3,
  Defense = 4,
  General = 5,
  DecayTime = 6,
  Combat = 7,
  MinLevel = 8,
  MinMagicLevel = 9,
  Vocation = 10,
  Rune = 11,
  Ability = 12,
  Charges = 13,
  WeaponName = 14,
  Weight = 15
}

MarketItemDescription.First = MarketItemDescription.Armor
MarketItemDescription.Last = MarketItemDescription.Weight

MarketItemDescriptionStrings = {
  [1] = 'Armor',
  [2] = 'Attack',
  [3] = 'Container',
  [4] = 'Defense',
  [5] = 'Description',
  [6] = 'Use Time',
  [7] = 'Combat',
  [8] = 'Min Level',
  [9] = 'Min Magic Level',
  [10] = 'Vocation',
  [11] = 'Rune',
  [12] = 'Ability',
  [13] = 'Charges',
  [14] = 'Weapon Type',
  [15] = 'Weight'
}

function getMarketDescriptionName(id)
  if table.haskey(MarketItemDescriptionStrings, id) then
    return MarketItemDescriptionStrings[id]
  end
end

function getMarketDescriptionId(name)
  local id = table.find(MarketItemDescriptionStrings, name)
  if id then
    return id
  end
end

MarketSlotFilters = {
  [InventorySlotOther] = "Two-Handed",
  [InventorySlotLeft] = "One-Handed",
  [255] = "Any"
}

MarketFilters = {
  Vocation = 1,
  Level = 2,
  Depot = 3,
  SearchAll = 4
}

MarketFilters.First = MarketFilters.vocation
MarketFilters.Last = MarketFilters.depot

function getMarketSlotFilterId(name)
  local id = table.find(MarketSlotFilters, name)
  if id then
    return id
  end
end

function getMarketSlotFilterName(id)
  if table.haskey(MarketSlotFilters, id) then
    return MarketSlotFilters[id]
  end
end
