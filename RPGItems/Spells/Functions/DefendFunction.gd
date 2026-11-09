extends SpellFunction

func requires_selection() -> bool:
    return false;

func specification() -> Enum.SpellSpecification:
    return Enum.SpellSpecification.Defend;

func spell_name() -> StringName:
    return &"Defend";

func cast(user: Entity, target: Entity, depth: int):
    if (user.stamina <= 0): return 0;
    user.stamina -= 1;
    if (user.defending_duration != 0): return 0;
    if (user.defense_stun): 
        user.defense_stun = false; 
        return 0;
    Audio.play_audio(Audio.defend_sfx);
    user.defending_duration = user.max_defending_duration;
    user.defense_durability = user.max_defense_durability;
    return depth;
