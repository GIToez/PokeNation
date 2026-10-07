# Add a PokeNation Shop product (Soul Coins)

The PokeNation Shop catalog is server data. Adding a product is one table entry in
`server/data/lib/ps/systems/057-soulShop.lua`; the client needs no change, because it draws
whatever catalog the server sends. Background and rules: [`../reference/SOUL_COINS.md`](../reference/SOUL_COINS.md).
Wire format: [`../reference/OPCODES.md`](../reference/OPCODES.md) §8.1.

Paths are relative to `server/` unless stated otherwise.

---

## 1. The chain

```
Client opens the shop  →  ext opcode 201 {"action":"fetch"}
        │
data/lib/ps/events/creaturescripts/onExtendedOpcode.lua   (creature event "ExtendedOpcode")
        ▼
data/lib/ps/systems/057-soulShop.lua   onSoulShopExtendedOpcode
        │  fetch    → sendCatalog (SOUL_SHOP_CATEGORIES + enabled SOUL_SHOP_PRODUCTS) + sendBalance
        │  purchase → look up the id in SOUL_SHOP_PRODUCTS, check quantity, charge
        │             accounts.soulcoins, grant, log, reply balance + msg
        ▼
client-pokenation/modules/game_shop/game_shop.lua   draws categories, offers, balance
```

The client sends only `{"id": "<product id>", "count": <quantity>}` (and an optional
`"target"`). The price the player sees comes from the catalog, but the price charged is always
read again from `SOUL_SHOP_PRODUCTS` on the server.

## 2. Add the entry

Append to `SOUL_SHOP_PRODUCTS`:

```lua
{ id = "repel_pack", category = "Items", type = "item", itemId = 12345 --[[ example id ]], count = 5, price = 2, maxQuantity = 10,
  description = "Five repels." },
```

| Field | Required | Meaning |
|---|---|---|
| `id` | yes | Stable product id, lowercase with underscores. It is stored in `datalog_shop_purchases.product_id`, so never reuse or rename an id that has been sold; disable it instead |
| `category` | yes | Must equal a `title` in `SOUL_SHOP_CATEGORIES`; otherwise the client drops the offer |
| `type` | yes | `"item"` (grants `count × quantity` of `itemId` with `doPlayerSafeAddItem`) or `"premium"` (grants `days × quantity` premium days) |
| `itemId` | for `item` | Server item id. Also used for the offer picture (`getItemClientId`) |
| `count` | for `item` | Items per unit |
| `days` | for `premium` | Premium days per unit |
| `price` | yes | Soul Coins per unit (integer > 0) |
| `maxQuantity` | no | Units per purchase, default 1. The client shows a second "Buy N" button when it is above 1 |
| `name` | no | Display name; default is the item name (or "Premium Account (N days)") |
| `description` | no | Text in the offer details |
| `enabled` | no | `false` hides the product and refuses purchases of it |

A new category is an entry in `SOUL_SHOP_CATEGORIES` (`title`, `iconId` = index in the client's
13×13 category icon strip).

A new product `type` (outfit, addon unlock, Pokémon) needs a branch in `grant()` that returns
`true` only when the grant really happened; on `false` the price is refunded.

## 3. Price rules

- Keep prices consistent with the Soul Trade NPC if it sells the same thing
  (`data/npc/scripts/soulTrade.lua`): premium 30 days = 10, stamina = 1, Egg Move Capsule = 1.
- Do not add a second currency, a discount computed on the client, or a price field in the
  request. The account balance `accounts.soulcoins` is the only one the shop charges.

## 4. Test

1. Restart the server (`tools/start_server.sh`); the file is loaded at start-up.
2. Seed a balance: `UPDATE accounts SET soulcoins = 20 WHERE name = 'admin';`
3. Open the shop in the PokeNation client (Store button) and buy the product; check the
   balance, the delivered item and the History tab.
4. In the database: `datalog_shop_purchases` has the row with `product_id`, `price` and
   `balance_after`; `datalog_coin_uses` has a row with `use = 13`.
5. Run the automated round trip: `python3 tools/pokenation_client_smoke.py --shop` after
   `mysql psoul < tools/pokenation_smoke/seed_smoke.sql`. It needs at least the 8 shipped offers.

## 5. Checklist

- [ ] `id` is new and stable
- [ ] `category` exists in `SOUL_SHOP_CATEGORIES`
- [ ] `itemId` exists in `data/items/items.xml` and has a client sprite
- [ ] price agrees with any NPC selling the same thing
- [ ] bought once in the client; balance, item and both log tables checked
- [ ] [`../reference/SOUL_COINS.md`](../reference/SOUL_COINS.md) catalog table updated
