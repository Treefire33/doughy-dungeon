extends Control
class_name DecisionPanel

signal sub_decision(decision: Enum.Decision);
signal depth_selected(depth: int);

@onready var options: Control = $Options;
@onready var attack_button: Button = $Options/Container/Attack;
@onready var spell_button: Button = $Options/Container/Spell;
@onready var rest_button: Button = $Options/Container/Rest;

@onready var spell_options: Control = $SpellOptions;
@onready var spell_attack: Button = $SpellOptions/Container/SpellAttack;
@onready var spell_defend: Button = $SpellOptions/Container/SpellDefend;
@onready var spell_retype: Button = $SpellOptions/Container/SpellRetype;

@onready var attack_options: Control = $AttackOptions;
@onready var attack_light: Button = $AttackOptions/Container/AttackLight;
@onready var attack_heavy: Button = $AttackOptions/Container/AttackHeavy;

@onready var depth_options: Control = $CountOptions;
@onready var depth_one: Button = $CountOptions/Container/DepthOne;
@onready var depth_two: Button = $CountOptions/Container/DepthTwo;
@onready var depth_three: Button = $CountOptions/Container/DepthThree;
@onready var depth_four: Button = $CountOptions/Container/DepthFour;

@onready var cancel_button: Button = $Cancel;
@onready var selection_prompt: Control = $SelectionPrompt;
@onready var selection_prompt_label: RichTextLabel = $SelectionPrompt/Label;

func load_decisions(player_ui: PlayerUI) -> void:
    attack_button.pressed.connect(player_decision.bind(player_ui, Enum.Decision.Attack));
    attack_light.pressed.connect(sub_decision.emit.bind(Enum.Decision.Attack));
    attack_heavy.pressed.connect(sub_decision.emit.bind(Enum.Decision.AttackHeavy));

    spell_button.pressed.connect(player_decision.bind(player_ui, Enum.Decision.Spell));
    spell_attack.pressed.connect(sub_decision.emit.bind(Enum.Decision.SpellAttack));
    spell_defend.pressed.connect(sub_decision.emit.bind(Enum.Decision.SpellDefend));
    spell_retype.pressed.connect(sub_decision.emit.bind(Enum.Decision.SpellRetype));

    depth_one.pressed.connect(depth_selected.emit.bind(1));
    depth_two.pressed.connect(depth_selected.emit.bind(2));
    depth_three.pressed.connect(depth_selected.emit.bind(3));
    depth_four.pressed.connect(depth_selected.emit.bind(4));

    rest_button.pressed.connect(player_decision.bind(player_ui, Enum.Decision.Rest));
    cancel_button.pressed.connect(player_ui._enemy_selected.emit.bind("RESET"));

func player_decision(player_ui: PlayerUI, decision: Enum.Decision):
    options.hide();
    var spec_decision: Enum.Decision = decision;
    var decision_count: int = 1;
    match (decision):
        Enum.Decision.Attack:
            selection_prompt_label.text = "Select Attack Type";
            selection_prompt.show();
            attack_options.show();
            spec_decision = await sub_decision;
            attack_options.hide();
            selection_prompt.hide();
        
        Enum.Decision.Spell:
            selection_prompt_label.text = "Select Spell";
            selection_prompt.show();
            spell_options.show();
            spec_decision = await sub_decision;
            spell_options.hide();
            selection_prompt.hide();
    
    if (spec_decision == Enum.Decision.AttackHeavy || spec_decision == Enum.Decision.Rest):
        selection_prompt_label.text = "Select Action Depth";
        selection_prompt.show();
        depth_options.show();
        decision_count = await depth_selected;
        depth_options.hide();
        selection_prompt.hide();
    
    var current_enemy: Variant = null;
    cancel_button.show();
    if (spec_decision == Enum.Decision.Attack || spec_decision == Enum.Decision.AttackHeavy || spec_decision == Enum.Decision.SpellAttack):
        player_ui.selecting_enemy = true;
        selection_prompt.show();
        selection_prompt_label.text = "Select an Enemy";
        current_enemy = await player_ui._enemy_selected;
        selection_prompt.hide();
        player_ui.selecting_enemy = false;
    cancel_button.hide();
    if (current_enemy is String):
        options.show();
        return;
    player_ui.player_decision.emit(spec_decision, current_enemy, decision_count);
    options.show();
