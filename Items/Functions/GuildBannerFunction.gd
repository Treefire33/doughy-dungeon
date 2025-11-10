extends ItemFunction

# (1, 2, 3) -> (3, 2, 1)
# Health, Stamina, Attack -> Attack, Stamina, Health
func purchased(player: Player, purchased: bool, stack_count: int):
    if (purchased):
        ItemUtils.show_custom_toast("The banner sets you in line with your priorities...");
    
    var temp_max = player.max_health;
    player.max_health = player.attack;
    player.attack = temp_max;
