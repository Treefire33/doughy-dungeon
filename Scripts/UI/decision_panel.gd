extends Control
class_name DecisionPanel

@export var options: Panel;
@export var attack_button: Button;
@export var spell_button: Button;
@export var rest_button: Button;
@export var spell_options: Control;
@export var spell_attack: Button;
@export var spell_defend: Button;
@export var spell_retype: Button;
@export var attack_options: Control;
@export var attack_light: Button;
@export var attack_heavy: Button;
@export var depth_options: Control;
@export var depth_one: Button;
@export var depth_two: Button;
@export var depth_three: Button;
@export var depth_four: Button;
@export var cancel_button: Button;
@export var selection_prompt: Control;
@export var selection_prompt_label: RichTextLabel;

# horrible
enum DecisionPage {
    BaseOptions, 
    AttackOptions, 
    SpellOptions, 
    DepthOptions,
    EnemySelect
}
var last_page: DecisionPage = DecisionPage.BaseOptions;
var current_page: DecisionPage = DecisionPage.BaseOptions;
@onready var action_pages = {
    # primary actions
    DecisionPage.BaseOptions: {
        "Page": self.options,
        "Primary": self.attack_button,
        "Secondary": self.spell_button,
        "Tertiary": self.rest_button
    },

    # attack options
    DecisionPage.AttackOptions: {
        "Page": self.attack_options,
        "Primary": self.attack_light,
        "Secondary": self.attack_heavy,
        "Quaternary": self.cancel_button
    },

    # spell options
    DecisionPage.SpellOptions: {
        "Page": self.spell_options,
        "Primary": self.spell_defend,
        "Secondary": self.spell_retype,
        "Tertiary": self.spell_attack,
        "Quaternary": self.cancel_button
    },

    # depth options
    DecisionPage.DepthOptions: {
        "Page": self.depth_options,
        "Primary": self.depth_one,
        "Secondary": self.depth_two,
        "Tertiary": self.depth_three,
        "Quinary": self.depth_four,
        "Quaternary": self.cancel_button
    },

    # blank page for enemy select
    DecisionPage.EnemySelect: {
        "Page": null,
        "Quaternary": self.cancel_button
    }
};

var player_ui: PlayerUI = null;
var _selected_decision: Enum.Decision = Enum.Decision.Attack;
var _selected_depth: int = 1;
var _selected_enemy: Variant = null;

func load_decisions(player_ui: PlayerUI) -> void:
    self.player_ui = player_ui;

    attack_button.pressed.connect(base_decision.bind(Enum.Decision.Attack));
    spell_button.pressed.connect(base_decision.bind(Enum.Decision.Spell));
    rest_button.pressed.connect(base_decision.bind(Enum.Decision.Rest));

    attack_light.pressed.connect(attack_decision.bind(Enum.Decision.Attack));
    attack_heavy.pressed.connect(attack_decision.bind(Enum.Decision.AttackHeavy));
    
    spell_defend.pressed.connect(spell_decision.bind(Enum.Decision.SpellDefend));
    spell_retype.pressed.connect(spell_decision.bind(Enum.Decision.SpellRetype));
    spell_attack.pressed.connect(spell_decision.bind(Enum.Decision.SpellAttack));

    depth_one.pressed.connect(depth_decision.bind(1));
    depth_two.pressed.connect(depth_decision.bind(2));
    depth_three.pressed.connect(depth_decision.bind(3));
    depth_four.pressed.connect(depth_decision.bind(4));

    cancel_button.pressed.connect(cancel_page);

func begin_decision():
    _selected_decision = Enum.Decision.Attack;
    _selected_depth = 1;
    _selected_enemy = null;
    move_page(DecisionPage.BaseOptions);
    self.visible = true;

func move_page(target_page: DecisionPage):
    if (self.action_pages.has(current_page) && self.action_pages[current_page]["Page"]): self.action_pages[current_page]["Page"].visible = false;
    if (self.action_pages.has(target_page) && self.action_pages[target_page]["Page"]): self.action_pages[target_page]["Page"].visible = true;
    last_page = current_page;
    current_page = target_page;
    selection_prompt.hide();
    cancel_button.hide();
    player_ui.making_decision = true;
    player_ui.selecting_enemy = false;

    match (current_page):
        DecisionPage.BaseOptions:
            player_ui.making_decision = false;
        DecisionPage.AttackOptions:
            selection_prompt_label.text = "Select Attack Type";
            selection_prompt.show();
            cancel_button.show();
        DecisionPage.SpellOptions:
            selection_prompt_label.text = "Select Spell";
            selection_prompt.show();
            cancel_button.show();
        DecisionPage.DepthOptions:
            selection_prompt_label.text = "Select Action Depth";
            selection_prompt.show();
            cancel_button.show();
        DecisionPage.EnemySelect:
            selection_prompt_label.text = "Select an Enemy";
            selection_prompt.show();
            cancel_button.show();
            player_ui.selecting_enemy = true;
            _selected_enemy = await player_ui._enemy_selected;
            enemy_select();

func cancel_page():
    match (current_page):
        DecisionPage.AttackOptions, DecisionPage.SpellOptions:
            move_page(DecisionPage.BaseOptions);
        DecisionPage.DepthOptions, DecisionPage.EnemySelect:
            move_page(last_page);

func base_decision(decision: Enum.Decision):
    _selected_decision = decision;
    match (decision):
        Enum.Decision.Attack:
            move_page(DecisionPage.AttackOptions);
        Enum.Decision.Spell:
            move_page(DecisionPage.SpellOptions);
        Enum.Decision.Rest:
            move_page(DecisionPage.DepthOptions);

func attack_decision(decision: Enum.Decision):
    _selected_decision = decision;
    if (decision == Enum.Decision.AttackHeavy): move_page(DecisionPage.DepthOptions);
    else: move_page(DecisionPage.EnemySelect);

func spell_decision(decision: Enum.Decision):
    _selected_decision = decision;
    if (decision == Enum.Decision.SpellAttack):
        move_page(DecisionPage.EnemySelect);
    else: submit_decision();

func depth_decision(depth: int):
    _selected_depth = depth;
    if (_selected_decision == Enum.Decision.AttackHeavy): move_page(DecisionPage.EnemySelect);
    else: submit_decision();

func enemy_select():
    player_ui.selecting_enemy = false;
    submit_decision();

func submit_decision():
    player_ui.making_decision = false;
    player_ui.player_decision.emit(_selected_decision, _selected_enemy, _selected_depth);
    self.visible = false;

var action_to_index: Array[String] = [
    "Primary", "Secondary",
    "Tertiary", "Quaternary",
    "Quinary"
];
var panel_dimensions: Dictionary = {
    false: {
        "position": Vector2(340, 230),
        "size": Vector2(120, 120)
    },
    true: {
        "position": Vector2(0, 310),
        "size": Vector2(800, 40)
    },
};
func horizify_panel():
    options.get_node("Container").vertical = !Settings.horiz_decision_panel;
    for prop in panel_dimensions[Settings.horiz_decision_panel]:
        options.set(prop, panel_dimensions[Settings.horiz_decision_panel][prop]);

func _ready() -> void:
    for page_index in action_pages:
        var page = action_pages[page_index];
        for action in page:
            if (action == "Page"): continue;
            var action_object: Button = page[action] as Button;
            AccessibilityHelper.make_keybind_helper(action_object, action);

    horizify_panel();

func _process(delta: float) -> void:
    if (!self.visible): return;
    
    for action in action_to_index:
        if (!Input.is_action_just_pressed(action)): continue;
        if (!(action_pages[current_page] as Dictionary).has(action)): return;
        (action_pages[current_page][action] as Button).pressed.emit();
