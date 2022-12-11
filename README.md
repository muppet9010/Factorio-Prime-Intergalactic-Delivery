# Factorio-Prime-Intergalactic-Delivery

A shopping point and GUI for buying various personal, infrastructure and mod items, plus some team upgrades with Factorio coins. Designed for streamers primarily.

![Mod's GUI](https://thumbs.gfycat.com/CheeryBothFreshwatereel-size_restricted.gif)

# Only handles vanilla Factorio items at present. Is a very old mod updated for a specific usage case.

Details
-----------

- Provides a shopping point with GUI to select items & upgrades to purchase via a basket system.
- Item categories include personal equipment and early construction robot items.
- Includes some team upgrades like movement speed, mining speed and inventory size.
- Item types, prices and bonus effects, and delivery process are all configurable via mod settings.
- Option to use a whitelist of player names who can use the shop.
- Option to disable the item categories from being hand crafted. This disables the technologies or removes the recipes from more generic technologies. May cause issues with other item mods.
- Single payment chest for all players to collect coins in to.
- Coins added as a requestable item to player and logistic filters.
- Factorio coins need to be acquired through other mods and can then be spent with this mod.
- Designed for use with Item Delivery Pod mod to make item delivery a bit more explosive. However, will work in a simpler mode without this, delivering to an output chest.
- Shopping GUI Interactions:
    - Left click on an item in the product catalogue or a button to do its action once.
    - Right click on an item in the product catalogue or a button to do the action 5 times. Only applies to quantities being added/removed from the basket.
    - When clicking on an item in the product catalogue hold Shift to add it straight to the shopping basket, rather than just to show its details.


Integrations To Other Mods
--------------------

- Item Deliver Pod:
    - Uses the mod to deliver purchased items to near the shop if mod option enabled for this.
- Muppet Streamer:
    - Will add an item for recruiting a team member if this Prime's mod setting has a cost set.
    - If Prime has an item in the shop the research for Recruiting a Team Member will need to be disabled by setting the researches cost to 0 in the Muppet Streamer mod. Otherwise a warning will be shown and the shop item won't do anything. Basically you can't increase the team member count by both the shop and research in the same game.
    - Mod options to set the items starting cost and level cost multiplier.
- Biter Extermination:
    - Will add an item for buying a Biter Extermination gas capsule. Advised to set the technologies cost to 0 to disable its research option, but won't cause any issues if not.


Remote Interface For Other Mods
-------------

- Get the payment chest entity. Useful for putting things like coins in it.
    - code: `remote.call("prime_intergalactic_delivery", "get_payment_chest")`
    - returns: a reference to the payment chest entity or `nil` if it doesn't exist (should only happen when the mod is first loading)


Muppet Coin Based Mod Collection
------------------

This mod is part of my collection of mods that use the vanilla Factorio coins. They are designed to work together or separately as required. You can also mix with other people's mods that use vanilla Factorio coins.

- Prime Intergalactic Delivery: a market to buy player items for coins.
- Item Delivery Pod: a crashing spaceship that can bring items to the map with an explosive delivery.
- Coin Generation: a mod with a variety of ways for players and streamers to generate/obtain coins.
- Streamlabs RCON Integration: an external tool that lets streamers trigger in game actions from Streamlabs: https://github.com/muppet9010/Streamlabs-Rcon-Integration

A number of my other mods are designed for streamers or have features to make them streamer friendly.


Random Notes
-------------

- Only supports the default navius surface and the default "player" force at present.
- Only offers vanilla items and a few selected mod's items. Is an expandable system within the mod however.


Testing Notes
-------------
Add a lot of coins to the input chest:
` /c __prime_intergalactic_delivery__ global.facility.paymentChest.insert{name="coin", count=100000} `