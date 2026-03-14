extends ItemFunction

@warning_ignore("unused_parameter", "shadowed_variable")
func decision(user: Entity, target: Entity, decision: Enum.Decision, room_manager: RoomManager, stack_count: int):
    if (user is not Player): return;
    if (decision != Enum.Decision.Rest): return;
    if (user.attack - 1 <= 0): return;
    
    ItemUtils.show_custom_toast("The Abyss Heart weakens you.");
    user.remove_stat_mod("abyssAttack");

@warning_ignore("unused_parameter", "shadowed_variable")
func room_decision(decision: Enum.RoomDecision, room_manager: RoomManager, stack_count: int):
    if (room_manager.player.max_health - 1 > 0):
        room_manager.player.remove_stat_mod("abyssHealth");
    room_manager.player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxStamina, 5, "abyssStamina");

    ItemUtils.show_custom_toast("The Abyss Heart energizes you.");

@warning_ignore("unused_parameter", "shadowed_variable")
func enemy_kill(player: Player, enemy: Enemy, room_manager: RoomManager, stack_count: int):
    player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.Attack, 1, "abyssAttack");
    ItemUtils.show_custom_toast("The Abyss Heart strengthens you.");

@warning_ignore("unused_parameter", "shadowed_variable")
func purchased(player: Player, purchased: bool, room_manager: RoomManager, stack_count: int):
    if (purchased): return false;
    if (player.max_stamina - 5 > 0):
        room_manager.player.remove_stat_mod("abyssStamina");
    player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxHealth, 1, "abyssHealth");
    
    ItemUtils.show_custom_toast("The Abyss Heart vitalizes you.");
