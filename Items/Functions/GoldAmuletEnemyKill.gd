func use(player: Player, enemy: Enemy):
	enemy.coin_drop_range = [enemy.coin_drop_range[0] + 5, enemy.coin_drop_range[1] + 10];
	return true;
