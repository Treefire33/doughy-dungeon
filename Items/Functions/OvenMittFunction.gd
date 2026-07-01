extends ItemFunction

func room_decision(decision: Enum.RoomDecision, room_manager: RoomManager, stack_count: int):
	if (decision == Enum.RoomDecision.StayClear):
		room_manager.streak_difficulty = 0;
		room_manager.streak_multiplier = 0;
		ItemUtils.show_custom_toast("The oven shuts off.");
	else:
		room_manager.streak_difficulty += 1;
		room_manager.streak_multiplier += 0.1;
		ItemUtils.show_custom_toast("The temperature rises...");