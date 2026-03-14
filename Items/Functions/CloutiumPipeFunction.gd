extends ItemFunction

@warning_ignore("unused_parameter", "shadowed_variable")
func decision(user: Entity, target: Entity, decision: Enum.Decision, room_manager: RoomManager, stack_count: int):
    if (user is not Player): return;
    if (decision != Enum.Decision.Attack): return;
    for enemy in room_manager.alive_enemies:
        if (enemy == target || enemy == null):
            continue;
        enemy.health -= (0.25 * stack_count) * user.attack;
