extends Control
class_name PlayerUI;

signal ui_done();
signal player_decision(decision: Enum.Decision, enemy: Enemy);
signal _enemy_selected();

# Export vars
@export var room_manager: RoomManager;
@export var stats_display: StatsDisplay;
@export var inventory_display: InventoryDisplay;
@export var decision_panel: DecisionPanel;
@export var room_select: RoomSelect;

# Misc UI
@onready var selection_box: TextureRect = $SelectionBox;
@onready var inventory_button: Button = $Stats/Inventory;
@onready var fade_panel: ColorRect = $FadePanel;
@onready var pause_game_button: Button = $PauseGame;
@onready var dialogue_box: DialogueBox = $DialogueBox;

# Safe Room Upgrading Panel
@onready var upgrades_panel: ColorRect = $Upgrades;
@onready var health_upgrade: Button = $Upgrades/Health;
@onready var stamina_upgrade: Button = $Upgrades/Stamina;
@onready var attack_upgrade: Button = $Upgrades/Attack;

# Enemy Selection
var selecting_enemy: bool = false;

# Safe Room Related
var in_safe_room: bool = false;
@onready var safe_room_proceed: Button = $SafeRoomProceed;

func move_selection_box(enemy: Enemy):
    selection_box.visible = true;
    if (enemy == null || enemy.health <= 0):
        selection_box.visible = false;
        return	

    selection_box.position = enemy.get_parent().position - selection_box.size / 2;

var translation_dict = {
    0: "health",
    1: "stamina",
    2: "attack"
}
func upgrade_stat(stat: int):
    if (!in_safe_room): return;
    match (stat):
        0:
            room_manager.player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxHealth, 5);
        1: 
            room_manager.player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.MaxStamina, 2);
        2:
            room_manager.player.add_stat_mod(Enum.ModifierType.Additive, Enum.StatType.Attack, 2);
    room_manager.player.health = room_manager.player.max_health;
    room_manager.player.stamina = room_manager.player.max_stamina;
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

func update_enemy_buttons():
    for enemy in room_manager.battle_manager.get_enemies():
        var tooltip: TooltipTrigger = enemy.hover_tooltip as TooltipTrigger;
        if (enemy == null || enemy.health <= 0):
            tooltip.text = "";
            continue;
        
        tooltip.text = enemy.name + \
        "\n[s=8](" + enemy.flavour_text.strip_escapes() + ")\n" + \
        "\n[s=8]Health: " + str(enemy.health) + "/" + str(enemy.max_health) + \
        "\n[s=8]Stamina: " + str(enemy.stamina) + "/" + str(enemy.max_stamina) + \
        "\n[s=8]Defending Turns Remaining: " + str(enemy.defending_duration) + \
        "\n[s=8]Defense Durability: " + str(enemy.defense_durability) + \
        "\n[s=8]Attack: " + str(enemy.attack)
    
func select_enemy(enemy: Enemy):
    if (!selecting_enemy):
        return
    if (enemy == null || enemy.health <= 0):
        return
    _enemy_selected.emit(enemy);

func _ready() -> void:
    room_manager.request_decision.connect(decision_panel.begin_decision);
    decision_panel.load_decisions(self);
    stats_display.update(room_manager);
    inventory_button.grab_focus();
    
    update_enemy_buttons();
    
    inventory_button.pressed.connect(func():
        inventory_display.update(room_manager, in_safe_room);
    )
    
    safe_room_proceed.pressed.connect(func():
        if (!in_safe_room):
            return
        room_select.room_decision.emit();
    );
    
    health_upgrade.pressed.connect(upgrade_stat.bind(0));
    stamina_upgrade.pressed.connect(upgrade_stat.bind(1));
    attack_upgrade.pressed.connect(upgrade_stat.bind(2));
    
    pause_game_button.pressed.connect(room_manager.pause_game)
    emit_signal("ui_done")
    
func update_ui():
    stats_display.update(room_manager);
    update_enemy_buttons();
    
var action_to_index: Dictionary[String, int] = {
    "Primary": 0,
    "Secondary": 1,
    "Tertiary": 2
};
func _input(event: InputEvent) -> void:
    if (Input.is_action_just_pressed("Quaternary")):
        if (selecting_enemy):
            _enemy_selected.emit("RESET");
            return;
        inventory_button.pressed.emit();
    
    if (Input.is_key_pressed(KEY_END)):
        GlobalPlayer.grounds_for_evil = 0;
        Audio.play_music(Audio.evilgrounds_music);
        get_tree().change_scene_to_file.call_deferred("res://Scenes/grounds_for_evil.tscn");
        return;

    if (room_select.visible):
        return;

    var decision = -1;
    for action in action_to_index:
        if (Input.is_action_just_pressed(action)):
            decision = action_to_index[action];
    
    if (decision == -1):
        return;
    
    if (decision >= room_manager.battle_manager.get_enemies().size()): return;
    if (selecting_enemy):
        var enemy = room_manager.battle_manager.get_enemies().get(decision);
        if (enemy == null):
            return;
        _enemy_selected.emit(enemy);
