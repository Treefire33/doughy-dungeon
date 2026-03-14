extends ItemFunction

func decision(user: Entity, target: Entity, decision: Enum.Decision, room_manager: RoomManager, stack_count: int):
    if (decision != Enum.Decision.Rest): return;
    if (user is not Player): return;

    user.health += 1 * stack_count;
