extends ItemFunction

func room_decision(room_manager: RoomManager, decision: Enum.RoomDecision, stack_count: int):
	if (decision == Enum.RoomDecision.StayClear):
		room_manager.streak_difficulty = 0;
		room_manager.streak_multiplier = 0;
		ItemUtils.show_custom_toast("The oven has been turned off.");
		# ToastParty.show({
		# "text": "Oven Mitt streak reset!",
		# "text_size": Settings.toast_size,
		# "bgcolor": Color(0, 0, 0, 1),
		# "color": Color(1, 1, 1, 1),
		# "gravity": "top",
		# "direction": "right",
		# });
	else:
		room_manager.streak_difficulty += 1;
		room_manager.streak_multiplier += 0.1;
		ItemUtils.show_custom_toast("The temperature increases...");
		# ToastParty.show({
		# "text": "Oven Mitt streak increased!",
		# "text_size": Settings.toast_size,
		# "bgcolor": Color(0, 0, 0, 1),
		# "color": Color(1, 1, 1, 1),
		# "gravity": "top",
		# "direction": "right",
		# });