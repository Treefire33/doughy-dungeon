func use(room_manager: RoomManager, decision: Enum.RoomDecision) -> bool:
	if (decision == Enum.RoomDecision.StayClear):
		room_manager.streak_difficulty = 0;
		room_manager.streak_multiplier = 0;
		ToastParty.show({
		"text": "Oven Mitt streak reset!",
		"text_size": Settings.toast_size,
		"bgcolor": Color(0, 0, 0, 1),
		"color": Color(1, 1, 1, 1),
		"gravity": "top",
		"direction": "right",
		});
		return false;
	else:
		room_manager.streak_difficulty += 1;
		room_manager.streak_multiplier += 0.1;
		ToastParty.show({
		"text": "Oven Mitt streak increased!",
		"text_size": Settings.toast_size,
		"bgcolor": Color(0, 0, 0, 1),
		"color": Color(1, 1, 1, 1),
		"gravity": "top",
		"direction": "right",
		});
	return true;
