func use(player: Player, target: Entity, decision: Enum.Decision):
	if (target == null): return false;
	if (decision != Enum.Decision.Attack): return false;
	if (target.defending_duration != 0): return false;;
	if (randi_range(0, 100) <= 25):
		target.health -= player.attack;
		return true;
	return false;
