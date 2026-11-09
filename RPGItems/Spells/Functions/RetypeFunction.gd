extends SpellFunction

func specification() -> Enum.SpellSpecification:
    return Enum.SpellSpecification.Activate;

func spell_name() -> StringName:
    return &"Retype";
