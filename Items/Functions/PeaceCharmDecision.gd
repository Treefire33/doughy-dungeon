func use(player: Player, target, decision: Enum.Decision) -> bool:
	if (decision == Enum.Decision.Attack): return false;
	if (randi_range(0, 100) <= 40):
		player.health += int(player.max_health * 0.4);
		return true;
	return false;
