extends Control
class_name RPGUI

@onready var dungeon_inspect: Panel = $Inspect;
@onready var dungeon_name: Label = $Inspect/DungeonInspect/Name;
@onready var dungeon_description: Label = $Inspect/DungeonInspect/Description;
@onready var static_prompt_dungeon: Label = $Inspect/DungeonInspect/StaticPrompt;
@onready var dialogue_box: DialogueBox = $DialogueBox;

@export var menu: Control;
@export var menu_resume: Button;
@export var menu_inventory: Button;
@export var menu_exit: Button;
@export var menu_settings: Button;

@export var inventory: RPGInventory;
@export var stats: RPGStats;

@export var mobile_ui: Control;
@export var mobile_joystick: VirtualJoystick;
@export var mobile_primary: Button;
@export var mobile_secondary: Button;
@export var mobile_tertiary: Button;
@export var mobile_quaternary: Button;

var _current_interactable: RPGInteractable = null;
var _invalid_dungeon: bool = false;

var _in_menu: bool = false;
var _in_interaction: bool = false;

func enter_dungeon():
    var tween = get_tree().create_tween();
    tween.set_parallel();
    tween.tween_property(self, "color", Color(0, 0, 0, 1), 0.8);
    tween.tween_property(self, "modulate", Color(0, 0, 0, 1), 0.8);
    await tween.finished;
    SuperLoader.switch_scene("res://Scenes/game.tscn");
    return true;

func inspect_dungeon(interaction_args: RPGEventBus.RPGInteractionArgs):
    assert(interaction_args.interaction_object is RPGDungeon);
    var dungeon_data: DungeonData = interaction_args.interaction_object.dungeon;

    _in_interaction = true;
    dungeon_inspect.visible = true;
    dungeon_name.text = dungeon_data.name;

    _invalid_dungeon = false;
    var failing_dungeon = Enum.Dungeon.Alcove;
    for requirement in dungeon_data.requirements:
        if (!GlobalPlayer.completed_dungeons[requirement]):
            failing_dungeon = requirement;
            _invalid_dungeon = true;
            break;

    if (_invalid_dungeon):
        dungeon_description.text = "Please complete %s before entering this dungeon." % Enum.Dungeon.keys()[failing_dungeon + 1];
    else:
        dungeon_description.text = "%s\n\n%d Rooms\nDifficulty %d-%d" % [
            dungeon_data.description, dungeon_data.room_count, 
            dungeon_data.minimum_difficulty, dungeon_data.maximum_difficulty
        ];

func start_dialogue(dialogue_args: RPGEventBus.RPGDialogueArgs):
    _in_menu = true;
    _toggle_mobile_controls(true);
    dialogue_box.start_dialogue.emit(dialogue_args);
    await dialogue_box.dialogue_finished;
    _toggle_mobile_controls(false);
    _in_menu = false;

func attempt_interaction():
    if (!_current_interactable || _in_menu || _in_interaction): return;
    RPGEventBus.fire_event(RPGEventBus.RPGInteractionArgs.new(RPGEventBus.RPGEventId.RPG_Interaction, _current_interactable));

func _toggle_mobile_controls(force_off: bool):
    if (force_off): mobile_ui.visible = false; return;

    var platform = OS.get_name();
    var controls_enabled = platform == "iOS" || platform == "Android" || Settings.mobile_control_override;
    mobile_ui.visible = controls_enabled;

func _ready() -> void:
    static_prompt_dungeon.text = Keybinds.format_action_string(static_prompt_dungeon.text);

    menu_resume.pressed.connect(func():
        _in_menu = false;
        menu.visible = false;
        inventory.visible = false;
        stats.visible = false;
    );
    AccessibilityHelper.make_keybind_helper(menu_resume, "Primary");

    menu_inventory.pressed.connect(func():
        inventory.visible = !inventory.visible;  
        stats.visible = !stats.visible;
    );
    AccessibilityHelper.make_keybind_helper(menu_inventory, "Tertiary");

    menu_exit.pressed.connect(func():
        Settings.game_paused = false;
        SuperLoader.switch_scene("res://Scenes/title_screen.tscn");
    );
    AccessibilityHelper.make_keybind_helper(menu_exit, "Quinary");

    menu_settings.pressed.connect(func():
        Settings.load_settings_menu(self);
    );
    AccessibilityHelper.make_keybind_helper(menu_settings, "Secondary");

    _toggle_mobile_controls(false);
    Settings.settings_changed.connect(func(setting_name: StringName):
        if (setting_name != &"mobile_control_override"): return;
        _toggle_mobile_controls(false);
    );

    mobile_primary.text = Keybinds.format_action_string(mobile_primary.text);
    mobile_secondary.text = Keybinds.format_action_string(mobile_secondary.text);
    mobile_tertiary.text = Keybinds.format_action_string(mobile_tertiary.text);
    mobile_quaternary.text = Keybinds.format_action_string(mobile_quaternary.text);

    mobile_primary.button_down.connect(Input.action_press.bind("Primary"));
    mobile_secondary.button_down.connect(Input.action_press.bind("Secondary"));
    mobile_tertiary.button_down.connect(Input.action_press.bind("Tertiary"));
    mobile_quaternary.button_down.connect(Input.action_press.bind("Quaternary"));

    mobile_primary.button_up.connect(Input.action_release.bind("Primary"));
    mobile_secondary.button_up.connect(Input.action_release.bind("Secondary"));
    mobile_tertiary.button_up.connect(Input.action_release.bind("Tertiary"));
    mobile_quaternary.button_up.connect(Input.action_release.bind("Quaternary"));

    RPGEventBus.connect_to_id(RPGEventBus.RPGEventId.RPG_InpsectDungeon, inspect_dungeon);
    RPGEventBus.connect_to_id(RPGEventBus.RPGEventId.RPG_Dialogue, start_dialogue);

func _process(delta: float) -> void:
    if (Input.is_action_just_pressed("Pause")):
        Settings.pause_game(self);
    if (dialogue_box.visible): return;

    if (_in_menu):
        if (Input.is_action_just_pressed("Primary")):
            menu_resume.pressed.emit();
            _in_menu = false;
        elif (Input.is_action_just_pressed("Secondary")):
            menu_settings.pressed.emit();
        elif (Input.is_action_just_pressed("Tertiary")):
            menu_inventory.pressed.emit();
        elif (Input.is_action_just_pressed("Quinary")):
            menu_exit.pressed.emit();
    elif (!_in_menu && !_in_interaction):
        if (Input.is_action_just_pressed("Primary")):
                attempt_interaction();
        elif (Input.is_action_just_pressed("Tertiary")):
            _in_menu = true;
            menu.visible = true;
    elif (_in_interaction):
        if (Input.is_action_just_pressed("Primary") && !_invalid_dungeon):
            RPGEventBus.fire_event(RPGEventBus.RPGInteractionArgs.new(RPGEventBus.RPGEventId.RPG_EnterDungeon, _current_interactable));
            enter_dungeon();
        elif (Input.is_action_just_pressed("Secondary")):
            _in_interaction = false;
            dungeon_inspect.visible = false;
