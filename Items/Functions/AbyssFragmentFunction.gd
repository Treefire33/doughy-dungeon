extends ItemFunction

func purchased(player: Player, purchased: bool, stack_count: int):
	if (!purchased): return;
	player.coins += randi_range(-100, 100);
	player.max_health -= 1;
	ItemUtils.show_activation_toast("Fragment");
	if (stack_count == 9):
		ItemUtils.show_custom_toast("The fragments have merged.");
		MidnightDebug.remove_item("AbyssFragment", 9);
		MidnightDebug.add_item("AbyssHeart");
		GlobalPlayer.has_abyss_heart = true;