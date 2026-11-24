extends Entity
class_name Player

@onready var shield: Sprite2D = $Shield;

@export var tattered_texture: SpriteFrames;
@export var guild_texture: SpriteFrames;

var coins: int = 15:
    get: return coins;
    set(value):
        stat_changed.emit(&"coins", coins, value);
        coins = value;
        
var items: Dictionary[String, int] = {};

var _max_rerolls: int = 1;
var max_rerolls: int:
    get:
        @warning_ignore("narrowing_conversion")
        return apply_stat_mods(Enum.StatType.Rerolls, _max_rerolls);

var rerolls: int = self._max_rerolls:
    get: return rerolls;
    set(value):
        rerolls = clampi(value, 0, max_rerolls);

func add_item(item_name: String):
    if (!items.get(item_name)):
        items[item_name] = 0;
    
    items[item_name] += 1;
    for item in items:
        var data: ItemData = ItemUtils.get_item_data(item);
        if (data.function == null): continue;
        ItemUtils._execute_item_func(data, "purchased", ItemFunction.ItemFunctionArgs.new_purchased_args(self, item_name == item));

func remove_item(item_name: String, count: int = 1):
    if (!items.get(item_name)): return;
    
    items[item_name] -= count;
    if (items[item_name] <= 0):
        items.erase(item_name);

func get_item_stack_by_name(item_name: String):
    for item in items:
        if (ItemUtils.get_item_data(item).name != item_name): continue;
        return items[item];

    return 1;

func turn(target: Entity, decision: Enum.Decision, count: int = 1, spell: SpellFunction = null) -> int:
    if (decision == Enum.Decision.Spell):
        if (spell == null): return 0;
        if (spell.requires_selection() && target == null): return 0;
        return spell.cast(self, target, count);
    return super.turn(target, decision, count, spell);

var player_animation_to_name = {
    Enum.PlayerAnimation.Idle: "Idle",
    Enum.PlayerAnimation.Attack: "Attack",
    Enum.PlayerAnimation.Defend: "DefendStart",
    Enum.PlayerAnimation.Rest: "Rest",
    Enum.PlayerAnimation.Dead: "Dead"
};
var decision_to_animation = {
    Enum.Decision.Attack: Enum.PlayerAnimation.Attack,
    Enum.Decision.AttackHeavy: Enum.PlayerAnimation.Attack,

    Enum.Decision.Spell: Enum.PlayerAnimation.Defend,

    Enum.Decision.Rest: Enum.PlayerAnimation.Rest,
}
func play_anim(decision: Enum.PlayerAnimation):
    # animator.speed_scale = Settings.game_speed;
    sprite.play(player_animation_to_name[decision]);

func update_shield():
    shield.visible = defense_durability != 0 && defending_duration != 0;
            
func _ready():
    load_entity(15, 12, 2, $Sprite, $StatusIcons);
    sprite.sprite_frames = GlobalPlayer.cloak.dungeon_cloak if !is_instance_valid(GlobalPlayer.cloak.dungeon_cloak) else tattered_texture;
    play_anim(Enum.PlayerAnimation.Idle);

    _max_health = GlobalPlayer.get_upgrade_stat("max_health");
    _max_stamina = GlobalPlayer.get_upgrade_stat("max_stamina");
    _attack = GlobalPlayer.get_upgrade_stat("attack");
    _max_defending_duration = GlobalPlayer.get_upgrade_stat("max_defense_duration");
    _max_defense_durability = GlobalPlayer.get_upgrade_stat("max_defense_durability");
    _speed = max(2, GlobalPlayer.get_upgrade_stat("speed"));

    stat_changed.connect(func(stat_name: StringName, prev: float, new: float):
        ItemUtils.activate_items(self, "stat_changed", ItemFunction.ItemFunctionArgs.new_stat_changed_args(self, stat_name, prev, new));
        if (stat_name == &"defense_durability"):
            shield.frame = 0;
            if (defense_durability == 0):
                shield.frame = 1;
    );
