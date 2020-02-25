local Utils = require("utility/utils")

if settings.startup["prime_intergalactic_delivery-shop_personal_equipment_block_crafting"].value then
    data.raw["technology"]["modular-armor"].enabled = false
    data.raw["technology"]["power-armor"].enabled = false
    data.raw["technology"]["power-armor-mk2"].enabled = false
    data.raw["technology"]["solar-panel-equipment"].enabled = false
    data.raw["technology"]["personal-laser-defense-equipment"].enabled = false
    data.raw["technology"]["discharge-defense-equipment"].enabled = false
    data.raw["technology"]["fusion-reactor-equipment"].enabled = false
    data.raw["technology"]["exoskeleton-equipment"].enabled = false
    data.raw["technology"]["personal-roboport-equipment"].enabled = false
    data.raw["technology"]["personal-roboport-mk2-equipment"].enabled = false
    data.raw["technology"]["battery-equipment"].enabled = false
    data.raw["technology"]["battery-mk2-equipment"].enabled = false
    data.raw["technology"]["belt-immunity-equipment"].enabled = false
    data.raw["technology"]["energy-shield-equipment"].enabled = false
    data.raw["technology"]["energy-shield-mk2-equipment"].enabled = false
    data.raw["technology"]["night-vision-equipment"].enabled = false
end

if settings.startup["prime_intergalactic_delivery-shop_infrastructure_block_crafting"].value then
    local constructionRoboticsTechEffects = data.raw["technology"]["construction-robotics"].effects
    table.remove(constructionRoboticsTechEffects, Utils.GetTableKeyWithInnerKeyValue(constructionRoboticsTechEffects, "recipe", "construction-robot"))
    table.remove(constructionRoboticsTechEffects, Utils.GetTableKeyWithInnerKeyValue(constructionRoboticsTechEffects, "recipe", "logistic-chest-storage"))
    table.remove(constructionRoboticsTechEffects, Utils.GetTableKeyWithInnerKeyValue(constructionRoboticsTechEffects, "recipe", "roboport"))

    local logisticRoboticsTechEffects = data.raw["technology"]["logistic-robotics"].effects
    table.remove(logisticRoboticsTechEffects, Utils.GetTableKeyWithInnerKeyValue(logisticRoboticsTechEffects, "recipe", "logistic-chest-storage"))
    table.remove(logisticRoboticsTechEffects, Utils.GetTableKeyWithInnerKeyValue(logisticRoboticsTechEffects, "recipe", "roboport"))
end
