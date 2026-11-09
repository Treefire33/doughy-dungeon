extends SpellFunction

func requires_selection() -> bool:
    return true;

func specification() -> Enum.SpellSpecification:
    return Enum.SpellSpecification.Attack;

func spell_name() -> StringName:
    return &"Attack";

func cast(user: Entity, target: Entity, depth: int):
    var damage = max(1, ceili(user.attack * 0.5));
    target.health -= damage;
    return depth;
