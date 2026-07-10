extends Control
class_name RPGUI

@onready var dungeon_inspect: Panel = $Inspect;
@onready var dungeon_name: Label = $Inspect/DungeonInspect/Name;
@onready var dungeon_description: Label = $Inspect/DungeonInspect/Description;
@onready var static_prompt_dungeon: Label = $Inspect/DungeonInspect/StaticPrompt;
@onready var dialogue_box: DialogueBox = $DialogueBox;

var _current_interactable: RPGInteractable = null;
var _in_menu: bool = false;

func enter_dungeon(dungeon: DungeonData):
    GlobalPlayer.current_dungeon = dungeon;
    var tween = get_tree().create_tween();
    tween.tween_property(self, "modulate", Color(0, 0, 0, 1), 0.8);
    await tween.finished;
    get_tree().change_scene_to_file("res://Scenes/game.tscn");
    return true;

func update_dungeon_inspect(dungeon: DungeonData):
    dungeon_inspect.visible = _in_menu;
    if (!_in_menu): return;
    dungeon_name.text = dungeon.name;
    dungeon_description.text = dungeon.description;

func attempt_interaction():
    if (!_current_interactable || _in_menu): return;
    
    if (_current_interactable is RPGDungeon):
        _in_menu = true;
        update_dungeon_inspect(_current_interactable.dungeon);
        return;
    elif (_current_interactable is RPGNpc):
        var dialogue = _current_interactable.get_dialogue(GlobalPlayer.current_scene);
        if (dialogue == null): return;
        _in_menu = true;
        dialogue_box.start_dialogue.emit(dialogue);
        await dialogue_box.dialogue_finished;
        _in_menu = false;
        return;

func _ready() -> void:
    static_prompt_dungeon.text = Keybinds.format_action_string(static_prompt_dungeon.text);

func _process(delta: float) -> void:
    if (Input.is_action_just_pressed("Primary")):
        if (!_in_menu): attempt_interaction(); return;
        if (_current_interactable is RPGDungeon):
            enter_dungeon(_current_interactable.dungeon);
        elif (_current_interactable is RPGNpc):
            dialogue_box.advance_dialogue();
    elif (Input.is_action_just_pressed("Secondary")):
        if (!_in_menu): return;
        if (_current_interactable is RPGDungeon):
            _in_menu = false;
            update_dungeon_inspect(_current_interactable.dungeon);
        elif (_current_interactable is RPGNpc):
            dialogue_box.skip_dialogue();

