extends ItemFunction

func decision(
    user: Entity, target: Entity, decision: Enum.Decision, 
    room_manager: RoomManager, stack_count: int
):
    if (user is not Player): return;

    if (decision == Enum.Decision.SpellDefend && !StatusEffect.has_effect(user, Enum.StatusEffect.Burn)):
        StatusEffect.apply_effect(user, 1, Enum.StatusEffect.Burn);
