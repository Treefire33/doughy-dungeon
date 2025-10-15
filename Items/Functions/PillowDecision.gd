func use(player: Player, _target: Entity, decision: Enum.Decision):
	if (decision != Enum.Decision.Rest): return false;
	player.stamina += 1;
	return true;
