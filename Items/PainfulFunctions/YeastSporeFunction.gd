extends ItemFunction

func decision(
    user: Entity, target: Entity, decision: Enum.Decision, 
    room_manager: RoomManager, stack_count: int
):
    if (user is not Player || decision != Enum.Decision.Rest): return;
    user.defending_duration -= 1;
