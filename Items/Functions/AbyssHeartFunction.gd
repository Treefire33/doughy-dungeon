extends ItemFunction

func decision(user: Entity, target: Entity, decision: Enum.Decision, stack_count: int):
	if (user is not Player): return;
	if (decision != Enum.Decision.Rest): return;
	if (user.attack - 1 <= 0): return;
	
	ItemUtils.show_custom_toast("The Abyss Heart weakens you.");
	user.attack -= 1;

func room_decision(room_manager: RoomManager, decision: Enum.RoomDecision, stack_count: int):
	if (room_manager.player.max_health - 1 > 0):
		room_manager.player.max_health -= 1;
	room_manager.player.max_stamina += 5;

	ItemUtils.show_custom_toast("The Abyss Heart energizes you.");

func enemy_kill(player: Player, enemy: Enemy, stack_count: int):
	player.attack += 1;
	ItemUtils.show_custom_toast("The Abyss Heart strengthens you.");

func purchased(player: Player, purchased: bool, stack_count: int):
	if (purchased): return false;
	player.max_health += 1;
	if (player.max_stamina - 5 > 0):
		player.max_stamina -= 5;
	
	ItemUtils.show_custom_toast("The Abyss Heart vitalizes you.");
