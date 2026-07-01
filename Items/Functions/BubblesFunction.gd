extends ItemFunction

@warning_ignore("unused_parameter", "shadowed_variable")
func purchased(player: Player, purchased: bool, room_manager: RoomManager, stack_count: int):
    player.add_stat_mod(Enum.ModifierType.Set, Enum.StatType.MaxDuration, 50);
    player.add_stat_mod(Enum.ModifierType.Set, Enum.StatType.MaxDurability, 1);
