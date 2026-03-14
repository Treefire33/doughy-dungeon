extends Node2D
class_name Entity
signal durability_changed;

static func sort_stat_mods(modA: StatModifier, modB: StatModifier):
    return modA.type < modB.type;
static func find_stat_mod(mod: StatModifier, key: String):
    return mod.key == key;

func apply_stat_mods(stat_type: Enum.StatType, stat_value: float) -> float:
    var stat = stat_value;
    for mod in self.stat_modifiers:
        if (mod.stat != stat_type): continue;
        stat = StatModifier.apply_modifier(mod, stat);
    return stat;

# Health
var _max_health: int:
    get: return _max_health;
    set (value):
        _max_health = clampi(value, 1, 5000);
        health = _max_health;

var max_health: int:
    get: 
        @warning_ignore("narrowing_conversion") 
        return apply_stat_mods(Enum.StatType.MaxHealth, _max_health);
var health: int:
    get: return health
    set (value):
        if (health > value):
            self.call_deferred("hurt");
        health = clampi(value, 0, max_health);

# Stamina
var _max_stamina: int:
    get: return _max_stamina;
    set (value):
        _max_stamina = clampi(value, 1, 5000);
        stamina = _max_stamina;

var max_stamina: int:
    get: 
        @warning_ignore("narrowing_conversion") 
        return apply_stat_mods(Enum.StatType.MaxStamina, _max_stamina);

var stamina: int:
    get: return stamina
    set (value):
        stamina = clampi(value, 0, max_stamina);

# Attack
var _attack: int = 1;
var attack:
    get: 
        @warning_ignore("narrowing_conversion") 
        return apply_stat_mods(Enum.StatType.Attack, _attack);

# Defense
var _max_defending_duration: int = 1;
var max_defending_duration: int:
    get: 
        @warning_ignore("narrowing_conversion") 
        return apply_stat_mods(Enum.StatType.MaxDuration, _max_defending_duration);

var defending_duration: int:
    get: return defending_duration;
    set (value):
        defending_duration = clampi(value, 0, max_defending_duration);

var _max_defense_durability: int = 1;
var max_defense_durability: int:
    get: 
        @warning_ignore("narrowing_conversion") 
        return apply_stat_mods(Enum.StatType.MaxDurability, _max_defense_durability);

var defense_durability: int = 1:
    get: return defense_durability;
    set(value): 
        defense_durability = clampi(value, 0, max_defense_durability);
        if (defense_durability == 0):
            defending_duration = 0;
            defense_broke_last_turn = true;
            defense_durability = max_defense_durability;
        durability_changed.emit();

var stat_modifiers: Array[StatModifier] = [];
func add_stat_mod(
    mod_type: Enum.ModifierType,
    stat_type: Enum.StatType,
    value: float,
    key: String = ""
) -> void:
    stat_modifiers.append(StatModifier.new(mod_type, stat_type, value, key));
    stat_modifiers.sort_custom(sort_stat_mods);

func update_stat_mod(key: String, value: float) -> void:
    var index = stat_modifiers.find_custom(find_stat_mod.bind(key));
    if (index < 0): return;
    var mod = stat_modifiers[index];
    mod.value = value;

func remove_stat_mod(key: String, remove_all: bool = false) -> void:
    var index = stat_modifiers.find_custom(find_stat_mod.bind(key));
    stat_modifiers.erase(stat_modifiers[index]);
    if (remove_all):
        while (index != -1):
            index = stat_modifiers.find_custom(find_stat_mod.bind(key));
            stat_modifiers.erase(stat_modifiers[index]);

var defense_broke_last_turn: bool = false;

var sprite: Sprite2D;
var animator: AnimationPlayer;

func hurt():
    self.sprite.modulate = Color(1, 1, 1, 0);
    var passes = 0;
    while (passes < 6):
        self.sprite.modulate = Color(1, 1, 1, 0 if passes % 2 == 0 else 1);
        await get_tree().create_timer(0.1 / Settings.game_speed).timeout;
        passes += 1;

@warning_ignore("shadowed_variable")
func load_entity(
    _max_health: int, 
    _max_stamina: int, 
    _attack: int, 
    _sprite: Sprite2D,
    _animator: AnimationPlayer
):
    self._max_health = _max_health;
    self._max_stamina = _max_stamina;
    self.attack = _attack;
    
    self.sprite = _sprite;
    self.animator = _animator;
