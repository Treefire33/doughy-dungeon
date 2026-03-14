extends ItemFunction

# (1, 2, 3) -> (3, 2, 1)
# Health, Stamina, Attack -> Attack, Stamina, Health
func purchased(player: Player, purchased: bool, room_manager: RoomManager, stack_count: int):
    if (purchased):
        ItemUtils.show_custom_toast("The banner sets you in line with your priorities...");
    
    # Can't use stat mods, would override items
    # I don't want to override.
    var temp_max = player._max_health;
    player._max_health = player._attack;
    player._attack = temp_max;
