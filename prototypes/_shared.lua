local Shared = {}

Shared.capsuleAction = {
    type = "use-on-self",
    attack_parameters = {
        type = "projectile",
        ammo_category = "capsule",
        cooldown = 0,
        range = 0,
        ammo_type = {
            category = "capsule",
            target_type = "position"
        }
    }
}

return Shared
