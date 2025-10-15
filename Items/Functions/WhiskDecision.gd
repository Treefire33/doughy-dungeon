func use(player: Player, target, decision: Enum.Decision) -> bool:
	if (decision != Enum.Decision.Attack): return false;
	target.health += player.attack;
	target.health -= randi_range(player.attack, player.max_health / 2);
	return true;
