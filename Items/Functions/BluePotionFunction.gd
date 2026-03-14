extends ItemFunction

@warning_ignore("unused_parameter", "shadowed_variable")
func purchased(player: Player, purchased: bool, room_manager: RoomManager, stack_count: int):
	if (!purchased): return;
	ItemUtils.show_activation_toast("Blue Potion");
	player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxDuration, 1, "bluePotion");
