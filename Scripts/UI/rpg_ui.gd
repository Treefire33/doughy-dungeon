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

@export var inventory: RPGInventory;

@export var mobile_ui: Control;
@export var mobile_joystick: VirtualJoystick;
@export var mobile_primary: Button;
@export var mobile_secondary: Button;
@export var mobile_tertiary: Button;
@export var mobile_quaternary: Button;

var _current_interactable: RPGInteractable = null;
var _in_menu: bool = false;

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

    _in_menu = true;
    dungeon_inspect.visible = true;
    dungeon_name.text = interaction_args.interaction_object.dungeon.name;
    dungeon_description.text = interaction_args.interaction_object.dungeon.description;

func start_dialogue(dialogue_args: RPGEventBus.RPGDialogueArgs):
    var dialogue = dialogue_args.dialogue;
    _in_menu = true;
    dialogue_box.start_dialogue.emit(dialogue);
    await dialogue_box.dialogue_finished;
    _in_menu = false;

func attempt_interaction():
    if (!_current_interactable || _in_menu): return;
    RPGEventBus.fire_event(RPGEventBus.RPGInteractionArgs.new(RPGEventBus.RPGEventId.RPG_Interaction, _current_interactable));

func _ready() -> void:
    static_prompt_dungeon.text = Keybinds.format_action_string(static_prompt_dungeon.text);

    menu_resume.pressed.connect(func():
        _in_menu = false;
        menu.visible = false;
        inventory.visible = false;
    );

    menu_inventory.pressed.connect(func():
        inventory.visible = !inventory.visible;  
    );

    menu_exit.pressed.connect(func():
        Settings.game_paused = false;
        SuperLoader.switch_scene("res://Scenes/title_screen.tscn");
    );

    var platform = OS.get_name();
    var controls_enabled = platform == "iOS" || platform == "Android" || Settings.mobile_control_override;
    mobile_ui.visible = controls_enabled;

    Settings.settings_changed.connect(func():
        mobile_ui.visible = platform == "iOS" || platform == "Android" || Settings.mobile_control_override;  
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

    if (Input.is_action_just_pressed("Primary")):
        if (!_in_menu): attempt_interaction(); return;
        RPGEventBus.fire_event(RPGEventBus.RPGInteractionArgs.new(RPGEventBus.RPGEventId.RPG_EnterDungeon, _current_interactable));
        enter_dungeon();
    elif (Input.is_action_just_pressed("Secondary")):
        if (!_in_menu): return;
        _in_menu = false;
        dungeon_inspect.visible = false;
    elif (Input.is_action_just_pressed("Tertiary")):
        if (_in_menu): 
            if (menu.visible):
                _in_menu = false;
                menu.visible = false;
            return;
        _in_menu = true;
        menu.visible = true;
