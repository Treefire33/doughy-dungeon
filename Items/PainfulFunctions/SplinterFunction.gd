extends ItemFunction

func decision(
    user: Entity, target: Entity, decision: Enum.Decision, 
    room_manager: RoomManager, stack_count: int
):
    if (user is Player || decision != Enum.Decision.Attack): return;
    if (target is not Player): return;
    target.health -= stack_count;
