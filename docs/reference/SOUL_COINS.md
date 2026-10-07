# Soul Coins

Soul Coins are PokeNation's only premium currency. There is no second currency, and the client
never decides a price or a balance. This page covers where Soul Coins live, every place that
spends them, and the PokeNation Shop (extended opcode 201). Wire format:
[`OPCODES.md`](OPCODES.md) §8.1. Adding a product: [`../tutorials/add-shop-product.md`](../tutorials/add-shop-product.md).

## 1. Two forms, one currency

| Form | Where | Read / written by |
|---|---|---|
| Account balance | `accounts.soulcoins` (INT, default 0; `server/src/schemas/psoul_extra_mysql.sql`) | credited from outside the game (website / payment, not part of this repository); debited by the Soul Trade "withdraw" service and by the PokeNation Shop |
| Item | item **6500** "soul coin" (`server/data/items/items.xml`), carried in the backpack | created by the Soul Trade "withdraw" service; consumed by the NPC services below |

"Withdraw" at a Soul Trade NPC moves coins from the account balance into 6500 items
(`soulTrade.lua`: `getPlayerAccountSoulCoins`, `setPlayerAccountSoulCoins`, `doPlayerAddItem`).
Nothing converts items back into the account balance.

The account balance is credited only from outside the game. A future payment integration
credits `accounts.soulcoins` on the web side; payment secrets never go into the client or the
game server's Lua.

## 2. Where Soul Coins are spent

Every spend is logged in `datalog_coin_uses (date, player_id, use, amount)` through
`doDatalogCoinUse` (`server/data/lib/ps/systems/025-datalog.lua`).

| `use` | Service | Pays with | Price | Code |
|---:|---|---|---:|---|
| 1 | Premium account, 30 days | item 6500 | 10 | `npc/scripts/soulTrade.lua` |
| 2 | Change sex | item 6500 | 3 | `soulTrade.lua` |
| 3 | Change city | — | — | commented out in `soulTrade.lua` |
| 4 | Bless | item 6500 | 1 | `soulTrade.lua` |
| 5 | Pokémon nickname | item 6500 | 1 | `soulTrade.lua` |
| 6 | Stamina recover | item 6500 | 1 | `soulTrade.lua` |
| 7 | Withdraw (account → items) | account balance | count | `soulTrade.lua` (also the unused `shop_bank.lua`) |
| 8 | Create guild | item 6500 | 5 | `soulTrade.lua` |
| 9 | Create guild rank | item 6500 | 1 | `soulTrade.lua` |
| 10 | Vitamin reset | item 6500 | 1 | `npc/scripts/vitamin_reset.lua` |
| 11 | Egg Move Capsule | item 6500 | 1 | `soulTrade.lua` |
| 12 | Pokémon addon | item 6500 | — | `soulTrade.lua` |
| 13 | PokeNation Shop purchase | account balance | product price × quantity | `lib/ps/systems/057-soulShop.lua` |

Soul Trade NPCs: the NPC XML files that use `soulTrade.lua` (Ben, Cairo, Carlisle, Cree, Curtis,
Dominick, Easton, Erik, Jackson, Lenard, …).

## 3. Dead code (kept, not loaded)

| What | Where | Why it is dead |
|---|---|---|
| `shop_bank.lua` | `server/data/npc/scripts/shop_bank.lua` | no NPC XML references it; duplicates the Soul Trade withdraw |
| Legacy "Diamond Shop" | `client/modules/game_shop/shop.lua` (frozen legacy client) | not in any load list of the legacy client; listened on ext opcode 103, which no server script sends |
| Stock Redemption game_shop (Tibia Coins, two currencies, auto `fetch` at login) | replaced in `client-pokenation/modules/game_shop/` | rewritten as the PokeNation Shop (§4) |
| CipSoft store (`game_store`) | `client-pokenation/modules/game_store/` | disabled; its `0xFA`/`0xFB` are PSoul's poll opcodes |

## 4. PokeNation Shop

Server: `server/data/lib/ps/systems/057-soulShop.lua`, dispatched from
`lib/ps/events/creaturescripts/onExtendedOpcode.lua` (creature event `ExtendedOpcode`).
Client: `client-pokenation/modules/game_shop/` (opened by the Store button of `game_mainpanel`).

### Rules

- The server owns the catalog (`SOUL_SHOP_CATEGORIES`, `SOUL_SHOP_PRODUCTS`), the prices, the
  balance, the grant and the log. The catalog sent to the client is display data only.
- The client sends a product id, a quantity and an optional target; nothing else is read from a
  purchase request. A price or balance in a request would be ignored.
- The client asks for the catalog only when the window opens and extended opcodes are enabled.
  Nothing is sent at login.
- Purchases debit `accounts.soulcoins`, the same balance as the Soul Trade withdraw. Carried
  6500 items stay an NPC payment method; the shop does not touch them.

### Purchase sequence

1. Look up the product by id; unknown or `enabled = false` → error "This product is not available."
2. Quantity must be an integer in `1 … maxQuantity` (default 1) → else "Invalid quantity."
3. A target other than the buyer → "Gifting is not available yet."
4. Charge: `UPDATE accounts SET soulcoins = soulcoins - price WHERE id = ? AND soulcoins >= price`,
   then `ROW_COUNT() = 1`. Check and debit are one statement, so the balance cannot go negative
   even if the website changes it at the same time.
5. Grant: `item` → `doPlayerSafeAddItem(itemId, count × quantity)`; `premium` →
   `doPlayerAddPremiumDays(days × quantity)`. If the grant fails, the price is refunded and an
   error is logged.
6. Log: `datalog_coin_uses` (use 13) and `datalog_shop_purchases (date, account_id, player_id,
   product_id, product_name, quantity, price, balance_after)`.
   The table is created by `psoul_extra_mysql.sql` (98 tables in total). A database imported
   before the shop has no such table: purchases still charge, grant and write
   `datalog_coin_uses`, but the history tab stays empty and the INSERT logs an SQL error.
   Re-run the `CREATE TABLE IF NOT EXISTS datalog_shop_purchases` statement from that file (or
   `tools/init_dev_database.sh --reset`).
7. Reply: `balance`, then `msg` "You bought …".

Requests are rate-limited per player and action to one per second.

### Catalog (current)

| Id | Category | Grants | Price | Max per purchase |
|---|---|---|---:|---:|
| `stamina_recover` | Items | item 13971 ×1 | 1 | 10 |
| `egg_move_capsule` | Items | item 28915 ×1 | 1 | 10 |
| `addon_fossilized_aerodactyl` | Pokemon Addons | item 29827 | 15 | 1 |
| `addon_fossilized_kabutops` | Pokemon Addons | item 29826 | 15 | 1 |
| `addon_fossilized_armaldo` | Pokemon Addons | item 29829 | 15 | 1 |
| `addon_fossilized_omastar` | Pokemon Addons | item 29830 | 15 | 1 |
| `addon_greybeard_costume` | Pokemon Addons | item 29855 | 15 | 1 |
| `premium_30_days` | Account | 30 premium days | 10 | 1 |

Prices match the Soul Trade NPC prices where the NPC sells the same thing (premium 10, stamina
1, Egg Move Capsule 1).

### Verified

GUI smoke `--shop` (CI job `gui-smoke`, seed `soulcoins = 20`): catalog and balance shown
(8 offers, 20); purchase 20 → 19 with "You bought 1x Stamina recover"; quantity 999 refused;
unknown product refused; a forged request `{id = "addon_fossilized_kabutops", count = 1,
price = 0}` charged the catalog price 15 (19 → 4); a second addon at balance 4 refused with no
debit; history lists both purchases. Screenshots `06-shop.png`, `07-shop-purchase.png`,
`08-shop-history.png`.
