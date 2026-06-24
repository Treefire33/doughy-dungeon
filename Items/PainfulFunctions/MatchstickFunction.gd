extends ItemFunction

var burn_turns_left: int = 0;

func decision(
    user: Entity, target: Entity, decision: Enum.Decision, 
    room_manager: RoomManager, stack_count: int
):
    if (user is not Player): return;

    if (decision == Enum.Decision.SpellDefend):
        burn_turns_left = 5;
    
    if (burn_turns_left == 0): return;
    burn_turns_left -= 1;
    user.health -= 2;
