extends ItemFunction

func purchased(
	player: Player, purchased: bool, 
	room_manager: RoomManager, stack_count: int
):
	if (!purchased): return;
	StatModifier.add_stat_mod(room_manager.room_stat_modifiers, Enum.ModifierType.Additive, Enum.StatType.RoomDifficulty, 1, "ovenMittStreakDiff");
	StatModifier.add_stat_mod(room_manager.room_stat_modifiers, Enum.ModifierType.Additive, Enum.StatType.RoomMultiplier, 0.1, "ovenMittStreakMult");

func room_decision(decision: Enum.RoomDecision, room_manager: RoomManager, stack_count: int):
	if (decision == Enum.RoomDecision.StayClear):
		StatModifier.update_stat_mod(room_manager.room_stat_modifiers, "ovenMittStreakDiff", 0);
		StatModifier.update_stat_mod(room_manager.room_stat_modifiers, "ovenMittStreakMult", 0);
		ItemUtils.show_custom_toast("The oven shuts off.");
	else:
		StatModifier.update_stat_mod(room_manager.room_stat_modifiers, "ovenMittStreakDiff", stack_count);
		StatModifier.update_stat_mod(room_manager.room_stat_modifiers, "ovenMittStreakMult", float(stack_count) / 10);
		ItemUtils.show_custom_toast("The temperature rises...");