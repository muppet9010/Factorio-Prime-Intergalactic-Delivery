local Utils = require("utility/utils")

local coin = data.raw["item"]["coin"]
coin.order = "z"
table.remove(coin.flags, Utils.GetTableKeyWithValue(coin, "hidden"))
