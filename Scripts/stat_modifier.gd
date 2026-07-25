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
        Enum.ModifierType.Preset:
            return modifier.value;
        Enum.ModifierType.Additive:
            return base + modifier.value;
        Enum.ModifierType.Multiplicative:
            return base * modifier.value;
        Enum.ModifierType.Exponential:
            return pow(base, modifier.value);
        Enum.ModifierType.Set:
            return modifier.value;
    return 1;

static func apply_stat_mods(modifiers: Array[StatModifier], stat_type: Enum.StatType, stat_value: float) -> float:
    var stat = stat_value;
    for mod in modifiers:
        if (mod.stat != stat_type): continue;
        stat = StatModifier.apply_modifier(mod, stat);
    return stat;

static func _sort_stat_mods(modA: StatModifier, modB: StatModifier):
    return modA.type < modB.type;
static func _find_stat_mod(mod: StatModifier, key: String):
    return mod.key == key;

static func add_stat_mod(
    modifiers: Array[StatModifier],
    mod_type: Enum.ModifierType,
    stat_type: Enum.StatType,
    value: float,
    key: String = ""
) -> void:
    modifiers.append(StatModifier.new(mod_type, stat_type, value, key));
    modifiers.sort_custom(_sort_stat_mods);

static func update_stat_mod(modifiers: Array[StatModifier], key: String, value: float) -> void:
    var index = modifiers.find_custom(_find_stat_mod.bind(key));
    if (index < 0): return;
    var mod = modifiers[index];
    mod.value = value;

static func remove_stat_mod(modifiers: Array[StatModifier], key: String, remove_all: bool = false) -> void:
    var index = modifiers.find_custom(_find_stat_mod.bind(key));
    while (index != -1):
        modifiers.erase(modifiers[index]);
        if (!remove_all): break;
        index = modifiers.find_custom(_find_stat_mod.bind(key));
