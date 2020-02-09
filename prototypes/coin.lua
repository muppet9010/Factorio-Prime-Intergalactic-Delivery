local Utils = require("utility/utils")

local coin = data.raw["item"]["coin"]
coin.order = "z"
coin.stack_size = settings.startup["prime_intergalactic_delivery-coin_stack_size"].value
table.remove(coin.flags, Utils.GetTableKeyWithValue(coin, "hidden"))
