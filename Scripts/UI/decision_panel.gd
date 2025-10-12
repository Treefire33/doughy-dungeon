extends ColorRect
class_name DecisionPanel

@onready var options: VBoxContainer = $Options;
@onready var attack_button: Button = $Options/Attack;
@onready var defend_button: Button = $Options/Defend;
@onready var rest_button: Button = $Options/Rest;
@onready var cancel_button: Button = $Cancel;

func load_decisions(player_ui: PlayerUI) -> void:
	attack_button.pressed.connect(give_decision.bind(player_ui, Enum.Decision.Attack));
	defend_button.pressed.connect(give_decision.bind(player_ui, Enum.Decision.Defend));
	rest_button.pressed.connect(give_decision.bind(player_ui, Enum.Decision.Rest));
	cancel_button.pressed.connect(player_ui._enemy_selected.emit.bind("RESET"));

func give_decision(player_ui: PlayerUI, decision: Enum.Decision):
	options.hide();
	self.color = Color(0, 0, 0, 0);
	cancel_button.show();
	var current_enemy: Variant = null;
	if (decision == Enum.Decision.Attack):
		player_ui.selecting_enemy = true;
		player_ui.select_enemy_panel.visible = true;
		current_enemy = await player_ui._enemy_selected;
		player_ui.select_enemy_panel.visible = false;
		player_ui.selecting_enemy = false;
	cancel_button.hide();
	if (current_enemy is String):
		options.show();
		self.color = Color(0, 0, 0, 1);
		return;
	player_ui.player_decision.emit(decision, current_enemy);
	self.color = Color(0, 0, 0, 1);
	options.show();
	self.hide();
