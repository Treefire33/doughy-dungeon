func use(room_manager: RoomManager, decision: Enum.RoomDecision) -> bool:
	if (room_manager.player.max_health - 1 > 0):
		room_manager.player.max_health -= 1;
	room_manager.player.max_stamina += 5;
	return true;
