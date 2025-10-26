func use(player: Player):
	player.coins += randi_range(-100, 100);
	player.max_health -= 1;
	if (player.get_item_count("Fragment of the Abyss") == 9):
		MidnightDebug.remove_item("Fragment of the Abyss", 9);
		MidnightDebug.add_item("AbyssHeart");
		GlobalPlayer.has_abyss_heart = true;
	return true;
