extends ItemFunction

func purchased(player: Player, purchased: bool, stack_count: int):
	if (!purchased): return;
	ItemUtils.show_activation_toast("Blue Potion");
	player.max_defending_duration += 1;
