extends ItemFunction

func decision(
    user: Entity, target: Entity, decision: Enum.Decision, 
    room_manager: RoomManager, stack_count: int
):
    if (user is not Player || !ItemUtils.decision_is_spell(decision)): return;

    user.stamina += 1 * stack_count;
