# Factorio-Prime-Intergalactic-Delivery
A shopping point and GUI for buying various personal, infrastructure and mod items, plus some team upgrades with Factorio coins. Designed for streamers primarily.

![Mod's GUI](https://thumbs.gfycat.com/CheeryBothFreshwatereel-size_restricted.gif)

Details
-----------

- Provides a shopping point with GUI to select items & upgrades to purchase via a basket system.
- Item categories include personal equipment and early construciton robot items.
- Includes some team upgrades like movement speed, mining speed and inventory size.
- Item types, prices and bonus effects and delivery process are all configurable via mod settings.
- Option to disable the items from being hand crafted.
- Payment must be in the payment chest to add some
- Coins added as a requestable item to player and logistic filters.
- Factorio coins need to be aquired through other mods and can then be spent with this mod.
- Designed for use with Item Delivery Pod mod to make item delivery a bit more explosive. However, will work in a simplier mod without this, delivering to an output chest.


Random Notes
-------------

- Only supports the default navius surface and the default "player" force at present.
- Only offers vanilla items and a few selected mod's items. Is an expandable system within the mod however.


Testing Notes
-------------
Add a lot of coins to the input chest:
` /c __prime_intergalactic_delivery__ global.facility.paymentChest.insert{name="coin", count=100000} `