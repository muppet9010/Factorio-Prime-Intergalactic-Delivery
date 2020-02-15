local Shared = require("prototypes/_shared")

if mods["muppet_streamer"] == nil then
    return
end

local recrutTeamMemberTechnology = data.raw["technology"]["muppet_streamer-recruit_team_member-1"]
data:extend(
    {
        {
            type = "capsule",
            name = "prime_intergalactic_delivery-recruit_team_member",
            icon = recrutTeamMemberTechnology.icon,
            icon_size = recrutTeamMemberTechnology.icon_size,
            icon_mipmaps = 1,
            flags = {"hidden"},
            subgroup = "other",
            order = "z",
            stack_size = 1,
            capsule_action = Shared.capsuleAction,
            localised_name = recrutTeamMemberTechnology.localised_name,
            localised_description = recrutTeamMemberTechnology.localised_description
        }
    }
)
