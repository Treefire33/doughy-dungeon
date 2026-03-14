class_name StatModifier

var key: String = "";
var value: float = 0.0;
var type: Enum.ModifierType = Enum.ModifierType.Additive;
var stat: Enum.StatType = Enum.StatType.Attack;

func _init(
    mod_type: Enum.ModifierType,
    stat_type: Enum.StatType,
    _value: float,
    _key: String = ""
) -> void:
    self.value = _value;
    self.stat = stat_type;
    self.type = mod_type;
    self.key = _key;

static func apply_modifier(modifier: StatModifier, base: float):
    match(modifier.type):
        Enum.ModifierType.Additive:
            return base + modifier.value;
        Enum.ModifierType.Multiplicative:
            return base * modifier.value;
        Enum.ModifierType.Exponential:
            return base * modifier.value;
        Enum.ModifierType.Set:
            return modifier.value;
