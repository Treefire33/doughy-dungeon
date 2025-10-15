func use(player: Player, _target: Entity, decision: Enum.Decision):
	if (decision != Enum.Decision.Rest): return false;
	if (player.attack - 1 <= 0): return false;
	
	player.attack -= 1;
	return true;
