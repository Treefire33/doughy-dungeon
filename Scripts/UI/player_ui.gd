extends Control
class_name PlayerUI;

signal ui_done;
signal player_decision(decision: Enum.Decision, enemy: Enemy);
signal room_decision(decision: Enum.RoomDecision);
signal _enemy_selected;

# Export vars
@export var room_manager: RoomManager;
@export var stats_display: StatsDisplay;
@export var inventory_display: InventoryDisplay;
@export var decision_panel: DecisionPanel;

# Misc UI
@onready var selection_box: TextureRect = $SelectionBox;
@onready var inventory_button: Button = $Stats/Inventory;
@onready var fade_panel: ColorRect = $FadePanel;
@onready var pause_game_button: Button = $PauseGame;

# Room Decision UI
@onready var room_deicision_ui: Control = $RoomDecision;
@onready var proceed_button: Button = $RoomDecision/Decision/Proceed;
@onready var risk_button: Button = $RoomDecision/Decision/Risk;
@onready var stay_clear_button: Button = $RoomDecision/Decision/StayClear;
@onready var description: RichTextLabel = $RoomDecision/Description/Description;

# Safe Room Upgrading Panel
@onready var upgrades_panel: ColorRect = $Upgrades;
@onready var health_upgrade: Button = $Upgrades/Health;
@onready var stamina_upgrade: Button = $Upgrades/Stamina;
@onready var attack_upgrade: Button = $Upgrades/Attack;

# Enemy Selection
@onready var select_enemy_label: Control = $Enemies/Label;
@onready var enemy_buttons: Array[Button] = [
	$Enemies/Enemy1,
	$Enemies/Enemy2,
	$Enemies/Enemy3,
];
var selecting_enemy: bool = false;

# Safe Room Related
var in_safe_room: bool = false;
@onready var safe_room_proceed: Button = $SafeRoomProceed;

func move_selection_box(enemy_index: int):
	selection_box.visible = true;
	if (
		enemy_index == -1 
		|| room_manager.alive_enemies[enemy_index] == null
	):
		selection_box.visible = false;
		return	

	selection_box.position = enemy_buttons[enemy_index].position;
		
var descriptions = {
	"Proceed": "Proceed\n\nAdvance to the next room.",
	"Risk": "Risk It\n\nNext room is 2 levels harder, but gives more rewards.",
	"StayClear": "Stay Clear\n\nSkip the next room and regenerate some stamina.\nNext room is a level harder."
}

func update_room_description(button_name):
	if (button_name == null):
		description.text = "";
		return;
	description.text = descriptions[button_name];
	
func request_room_decision(decision: Enum.RoomDecision):
	room_decision.emit(decision)
	room_deicision_ui.visible = false;

var translation_dict = {
	0: "health",
	1: "stamina",
	2: "attack"
}
func upgrade_stat(stat: int):
	if (!in_safe_room): return;
	match (stat):
		0:
			room_manager.player.max_health += 5;
		1: 
			room_manager.player.max_stamina += 2;
		2:
			room_manager.player.attack += 2;
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
	for i in len(room_manager.alive_enemies):
		var button: Button = enemy_buttons[i];
		var enemy: Enemy = room_manager.alive_enemies[i];
		if (enemy == null):
			continue;
		
		button.tooltip_text = enemy.name + \
		"\n(" + enemy.flavour_text + ")\n" + \
		"\nHealth: " + str(enemy.health) + "/" + str(enemy.max_health) + \
		"\nStamina: " + str(enemy.stamina) + "/" + str(enemy.max_stamina) + \
		"\nDefending Turns Remaining: " + str(enemy.defending_duration) + \
		"\nAttack: " + str(enemy.attack)
	
func select_enemy(enemy_index: int):
	if (!selecting_enemy):
			return
	_enemy_selected.emit(room_manager.alive_enemies[enemy_index]);

func _ready() -> void:
	decision_panel.load_decisions(self);
	stats_display.update(room_manager);
	inventory_button.grab_focus();
	
	var i = 0;
	for button in enemy_buttons:
		button.pressed.connect(select_enemy.bind(i));
		button.mouse_entered.connect(move_selection_box.bind(i))
		button.mouse_exited.connect(move_selection_box.bind(-1))
		i += 1;
	update_enemy_buttons();
	
	inventory_button.pressed.connect(func():
		inventory_display.update(room_manager, in_safe_room);
	)
	
	proceed_button.mouse_entered.connect(update_room_description.bind(proceed_button.name))
	proceed_button.mouse_exited.connect(update_room_description.bind(null))
	proceed_button.pressed.connect(request_room_decision.bind(Enum.RoomDecision.Proceed))
	
	risk_button.mouse_entered.connect(update_room_description.bind(risk_button.name))
	risk_button.mouse_exited.connect(update_room_description.bind(null))
	risk_button.pressed.connect(request_room_decision.bind(Enum.RoomDecision.RiskIt))
	
	stay_clear_button.mouse_entered.connect(update_room_description.bind(stay_clear_button.name))
	stay_clear_button.mouse_exited.connect(update_room_description.bind(null))
	stay_clear_button.pressed.connect(request_room_decision.bind(Enum.RoomDecision.StayClear))
	
	safe_room_proceed.pressed.connect(func():
		if (!in_safe_room):
			return
		room_decision.emit();
	);
	
	health_upgrade.pressed.connect(upgrade_stat.bind(0));
	stamina_upgrade.pressed.connect(upgrade_stat.bind(1));
	attack_upgrade.pressed.connect(upgrade_stat.bind(2));
	
	pause_game_button.pressed.connect(room_manager.pause_game)
	emit_signal("ui_done")
	
func update_ui():
	stats_display.update(room_manager)
	update_enemy_buttons()
	
var action_to_index: Dictionary[String, int] = {
	"Primary": 0,
	"Secondary": 1,
	"Tertiary": 2
};
func _input(event: InputEvent) -> void:
	if (Input.is_action_just_pressed("Quaternary")):
		inventory_button.pressed.emit();
	
	var decision = -1;
	for action in action_to_index:
		if (Input.is_action_just_pressed(action)):
			decision = action_to_index[action];
	
	if (decision == -1):
		return;
	
	if (selecting_enemy):
		var enemy = room_manager.alive_enemies[decision];
		if (enemy == null):
			return;
		_enemy_selected.emit(enemy);
	elif (decision_panel.visible):
		decision_panel.give_decision(self, decision);
	elif (room_deicision_ui.visible):
		request_room_decision(decision);

func _on_room_manager_request_decision() -> void:
	decision_panel.show();
