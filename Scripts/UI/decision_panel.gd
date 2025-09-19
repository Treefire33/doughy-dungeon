extends Control
class_name DecisionPanel

@onready var attack_button: Button = $Attack;
@onready var defend_button: Button = $Defend;
@onready var rest_button: Button = $Rest;

func load_decisions(player_ui: PlayerUI) -> void:
	attack_button.pressed.connect(give_decision.bind(player_ui, Enum.Decision.Attack))
	defend_button.pressed.connect(give_decision.bind(player_ui, Enum.Decision.Defend))
	rest_button.pressed.connect(give_decision.bind(player_ui, Enum.Decision.Rest))

func give_decision(player_ui: PlayerUI, decision: Enum.Decision):
	self.hide();
	var current_enemy: Enemy = null;
	if (decision == Enum.Decision.Attack):
		player_ui.selecting_enemy = true;
		player_ui.select_enemy_label.visible = true;
		current_enemy = await player_ui._enemy_selected;
		player_ui.select_enemy_label.visible = false;
		player_ui.selecting_enemy = false;
	player_ui.player_decision.emit(decision, current_enemy);
