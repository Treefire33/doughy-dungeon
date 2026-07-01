extends ItemFunction

func decision(
    user: Entity, target: Entity, decision: Enum.Decision, 
    room_manager: RoomManager, stack_count: int
):
    if (user is not Player || !ItemUtils.decision_is_attack(decision)): return;
    if (randf_range(0, 100) > 15 * (stack_count / 3.0)): return;
    user.health -= user.attack;
