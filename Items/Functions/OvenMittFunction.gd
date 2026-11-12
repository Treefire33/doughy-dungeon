extends ItemFunction

func purchased(args: ItemFunction.ItemFunctionArgs):
	if (!args.purchased): return;
	StatModifier.add_stat_mod(args.room_manager.room_stat_modifiers, Enum.ModifierType.Additive, Enum.StatType.RoomDifficulty, 1, "ovenMittStreakDiff");
	StatModifier.add_stat_mod(args.room_manager.room_stat_modifiers, Enum.ModifierType.Additive, Enum.StatType.RoomMultiplier, 0.1, "ovenMittStreakMult");

func room_decision(args: ItemFunction.ItemFunctionArgs):
	if (args.decision == Enum.RoomDecision.StayClear):
		StatModifier.update_stat_mod(args.room_manager.room_stat_modifiers, "ovenMittStreakDiff", 0);
		StatModifier.update_stat_mod(args.room_manager.room_stat_modifiers, "ovenMittStreakMult", 0);
		ItemUtils.show_custom_toast("The oven shuts off.");
	else:
		StatModifier.update_stat_mod(args.room_manager.room_stat_modifiers, "ovenMittStreakDiff", args.stack_count);
		StatModifier.update_stat_mod(args.room_manager.room_stat_modifiers, "ovenMittStreakMult", float(args.stack_count) / 10);
		ItemUtils.show_custom_toast("The temperature rises...");