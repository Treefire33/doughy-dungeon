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

var _current_interactable: RPGInteractable = null;
var _in_menu: bool = false;
var _in_dialogue: bool = false;

func enter_dungeon():
    var tween = get_tree().create_tween();
    tween.set_parallel();
    tween.tween_property(self, "color", Color(0, 0, 0, 1), 0.8);
    tween.tween_property(self, "modulate", Color(0, 0, 0, 1), 0.8);
    await tween.finished;
    get_tree().change_scene_to_file("res://Scenes/game.tscn");
    return true;

func inspect_dungeon(interaction_args: RPGEventBus.RPGInteractionArgs):
    assert(interaction_args.interaction_object is RPGDungeon);

    _in_menu = true;
    dungeon_inspect.visible = true;
    dungeon_name.text = interaction_args.interaction_object.dungeon.name;
    dungeon_description.text = interaction_args.interaction_object.dungeon.description;

func start_dialogue(interaction_args: RPGEventBus.RPGInteractionArgs):
    assert(interaction_args.interaction_object.get("dialogue_dict"));
    
    var dialogue = interaction_args.interaction_object.dialogue_dict[GlobalPlayer.current_scene];
    _in_menu = true;
    _in_dialogue = true;
    dialogue_box.start_dialogue.emit(dialogue);
    await dialogue_box.dialogue_finished;
    _in_dialogue = false;
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
        get_tree().change_scene_to_file("res://Scenes/title_screen.tscn");
    );

    RPGEventBus.connect_to_id(RPGEventBus.RPGEventId.RPG_InpsectDungeon, inspect_dungeon);
    RPGEventBus.connect_to_id(RPGEventBus.RPGEventId.RPG_Dialogue, start_dialogue);

func _process(delta: float) -> void:
    if (Input.is_action_just_pressed("Primary")):
        if (!_in_menu): attempt_interaction(); return;
        if (_in_dialogue): 
            dialogue_box.advance_dialogue();
        else:
            RPGEventBus.fire_event(RPGEventBus.RPGInteractionArgs.new(RPGEventBus.RPGEventId.RPG_EnterDungeon, _current_interactable));
            enter_dungeon();
    elif (Input.is_action_just_pressed("Secondary")):
        if (!_in_menu): return;
        if (_in_dialogue):
            dialogue_box.skip_dialogue();
        else:
            _in_menu = false;
            dungeon_inspect.visible = false;
    elif (Input.is_action_just_pressed("Quaternary")):
        if (_in_menu): 
            if (menu.visible):
                _in_menu = false;
                menu.visible = false;
            return;
        _in_menu = true;
        menu.visible = true;
    elif (Input.is_action_just_pressed("Pause")):
        Settings.pause_game(self);
