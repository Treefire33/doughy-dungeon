extends Control
class_name PlayerUI;

signal _enemy_selected();

# Export vars
@export var room_manager: RoomManager;
@export var player: Player;
@export var stats_display: StatsDisplay;
@export var inventory_display: InventoryDisplay;
@export var decision_panel: DecisionPanel;
@export var room_select: RoomSelect;

# Misc UI
@onready var selection_box: Control = $SelectionBox;
@onready var inventory_button: Button = $Stats/Inventory;
@onready var fade_panel: ColorRect = $FadePanel;
@onready var pause_game_button: Button = $PauseGame;
@onready var show_room_select_button: Button = $ShowRoomSelect;
@onready var dialogue_box: DialogueBox = $DialogueBox;
@onready var game_completed: GameOver = $GameComplete;

# Safe Room Upgrading Panel
@onready var upgrades_panel: Control = $Upgrades;
@onready var health_upgrade: Button = $Upgrades/Health;
@onready var stamina_upgrade: Button = $Upgrades/Stamina;
@onready var attack_upgrade: Button = $Upgrades/Attack;

# Turn Order
@onready var turn_order_icons: Array[AtlasTexture] = [
    preload("res://Sprites/Icons/MenuIcons/Midnight.tres"),
    preload("res://Sprites/Icons/MenuIcons/Enemy.tres")
];

@export var turn_order_prototype: TooltipTrigger;
@export var turn_order_container: Container;

# Decision
var selecting_enemy: bool = false;
var making_decision: bool = false;

# Safe Room Related
var in_safe_room: bool = false;
@onready var safe_room_proceed: Button = $SafeRoomProceed;
@onready var safe_room_reroll: Button = $SafeRoomReroll;

func move_selection_box(entity: Entity):
    if (entity == null || entity.health <= 0):
        selection_box.visible = false;
        return	

    selection_box.size = entity.sprite.sprite_frames.get_frame_texture(entity.sprite.animation, 0).get_size() * entity.global_scale;
    selection_box.position = entity.global_position - selection_box.size / 2;
    selection_box.visible = true;

var translation_dict = {
    0: "health",
    1: "stamina",
    2: "attack"
}
func upgrade_stat(stat: int):
    if (!in_safe_room): return;
    match (stat):
        0:
            player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxHealth, 5);
        1: 
            player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxStamina, 3);
        2:
            player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.Attack, 2);
    player.health = player.max_health;
    player.stamina = player.max_stamina;
    ToastParty.show({
        "text": "Applied %s upgrade!" % translation_dict[stat],
        "text_size": Settings.toast_size,
        "bgcolor": Color(0, 0, 0, 1),
        "color": Color(1, 1, 1, 1),
        "gravity": "top",
        "direction": "right",
    })
    stats_display.update(room_manager);
    upgrades_panel.hide();

const enemy_tooltip: String = (
"""%s
[font_size=8](%s)

Health: %d/%d
Stamina: %d/%d
Defense Duration: %d/%d
Defense Durability: %d/%d
Attack: %d[/font_size]"""
);
func update_enemy_buttons():
    for enemy in room_manager.battle_manager.get_enemies():
        var tooltip: TooltipTrigger = enemy.hover_tooltip;
        if (enemy == null || enemy.health <= 0):
            tooltip.tooltip_strings.clear();
            tooltip.visible = false;
            continue;
        
        tooltip.visible = true;
        tooltip.tooltip_strings.clear();
        tooltip.tooltip_strings.append(enemy_tooltip % [
            enemy.name, enemy.flavour_text,
            enemy.health, enemy.max_health,
            enemy.stamina, enemy.max_stamina,
            enemy.defending_duration, enemy.max_defending_duration,
            enemy.defense_durability, enemy.max_defense_durability,
            enemy.attack
        ]);
    
func select_enemy(enemy: Enemy):
    if (!selecting_enemy):
        return
    if (enemy == null || enemy.health <= 0):
        return
    _enemy_selected.emit(enemy);

func update_ui():
    stats_display.update(room_manager);
    update_enemy_buttons();

func reset_turn_order():
    for indicator in turn_order_container.get_children():
        indicator.queue_free();

func add_to_turn_order(entity: Entity):
    if (entity.health <= 0): return;
    var new_indicator = turn_order_prototype.duplicate(DUPLICATE_SCRIPTS);
    new_indicator.icon = turn_order_icons[0 if entity is Player else 1];
    new_indicator.tooltip_strings = [
        entity.name + "\n[font_size=8]Speed: %d[/font_size]" % entity.speed
    ] as Array[String];

    new_indicator.mouse_entered.connect(move_selection_box.bind(entity));
    new_indicator.mouse_exited.connect(move_selection_box.bind(null));

    new_indicator.visible = true;
    turn_order_container.add_child(new_indicator);

func toggle_safe_room(state: bool):
    safe_room_proceed.visible = state;
    safe_room_reroll.visible = state;
    upgrades_panel.visible = state;
    in_safe_room = state;
    update_ui();

var previewing_room_select: bool = false;
func _ready() -> void:
    room_manager.battle_manager.request_decision.connect(decision_panel.begin_decision);
    decision_panel.load_decisions(self);
    stats_display.update(room_manager);
    
    update_enemy_buttons();
    
    inventory_button.pressed.connect(func():
        inventory_display.update(room_manager, in_safe_room);
    );
    
    safe_room_proceed.pressed.connect(func():
        if (!in_safe_room):
            return;
        room_select.room_decision.emit();
    );
    safe_room_reroll.pressed.connect(func():
        room_manager.gen_safe_room_items();
        player.rerolls -= 1;
        safe_room_reroll.text = "Reroll (%d)" % player.rerolls;
        if (player.rerolls <= 0):
            safe_room_reroll.hide();
    );
    
    health_upgrade.pressed.connect(upgrade_stat.bind(0));
    stamina_upgrade.pressed.connect(upgrade_stat.bind(1));
    attack_upgrade.pressed.connect(upgrade_stat.bind(2));
    
    pause_game_button.pressed.connect(Settings.pause_game.bind(self));
    show_room_select_button.pressed.connect(func():
        previewing_room_select = !previewing_room_select;
        fade_panel.modulate = Color(1, 1, 1, int(previewing_room_select));
        fade_panel.visible = previewing_room_select;
        room_select.visible = previewing_room_select;
    );

    player.stat_changed.connect(func(_a, _b, _c):
        update_ui();
    );
    
var action_to_index: Dictionary[String, int] = {
    "Primary": 0,
    "Secondary": 1,
    "Tertiary": 2
};
func _process(delta: float) -> void:
    if (Input.is_action_just_pressed("Pause")):
        Settings.pause_game(self);

    if (Input.is_key_pressed(KEY_END)):
        SuperLoader.switch_scene.call_deferred("res://Scenes/grounds_for_evil.tscn");
        return;
    
    if (Input.is_action_just_pressed("Quaternary") && !making_decision):
        inventory_button.pressed.emit();

    if (room_select.visible && !previewing_room_select):
        show_room_select_button.visible = false;
        room_select.selection_accept.disabled = false;
        return;
    else:
        show_room_select_button.visible = true;
        room_select.selection_accept.disabled = true;

    var decision = -1;
    for action in action_to_index:
        if (Input.is_action_just_pressed(action)):
            decision = action_to_index[action];
    
    if (decision == -1):
        return;
    
    if (decision >= room_manager.battle_manager.get_enemies().size()): return;
    if (selecting_enemy):
        var enemy = room_manager.battle_manager.get_enemies().get(decision);
        if (enemy == null || enemy.health <= 0):
            return;
        _enemy_selected.emit(enemy);
