extends Control
class_name DialogueBox

signal start_dialogue(dialogue: RPGEventBus.RPGDialogueArgs);
signal dialogue_finished();

@export var background: Panel;
@export var icon: AnimatedTextureRect;
@export var dialogue_label: DialogueLabel;
@export var dialogue_responses: DialogueResponsesMenu;

@export var button_advance: Button;
@export var button_skip: Button;
@export var button_skip_complete: Button;

var current_dialogue: RPGEventBus.RPGDialogueArgs;
var current_line: DialogueLine;
var next_line: String = "start";

const dialogue_character: Dictionary[String, SpriteFrames] = {
    "Midnight": preload("res://Sprites/Dialogue/midnight_icons.aseprite"),
    "Vendor": preload("res://Sprites/Dialogue/vendor_icons.aseprite"),
    "ERROR": preload("res://Sprites/Dialogue/error_icons.aseprite")
};

func init_dialogue(dialogue: RPGEventBus.RPGDialogueArgs):
    current_dialogue = dialogue;
    next_line = "start";
    advance_dialogue();

func _set_dialogue_character():
    var emotion_tag = "neutral";
    if (current_line.tags.size() > 0):
        emotion_tag = current_line.tags[0];
    var character = dialogue_character.get(current_line.character);
    icon.visible = false;
    if (is_instance_valid(character)):
        icon.frames = character;
        icon.play(emotion_tag);
    icon.visible = is_instance_valid(character);

func advance_dialogue():
    if (dialogue_label.is_typing): return;
    current_line = await current_dialogue.dialogue.get_next_dialogue_line(next_line, [ {"speaker": current_dialogue.interaction_object} ]);
    if (!current_line): finish_dialogue(); return;

    dialogue_responses.visible = false;
    dialogue_responses.responses = current_line.responses;

    _set_dialogue_character();
    if (!self.visible): self.visible = true;

    next_line = current_line.next_id;
    current_line.text = Keybinds.format_action_string(current_line.text);
    dialogue_label.dialogue_line = current_line;
    dialogue_label.type_out();
    if (current_line.responses.size() > 0):
        dialogue_responses.visible = true;

func skip_dialogue():
    dialogue_label.skip_typing();

func finish_dialogue():
    dialogue_finished.emit();
    self.visible = false;
    current_dialogue = null;
    current_line = null;

func _ready() -> void:
    start_dialogue.connect(func(dialogue: RPGEventBus.RPGEventArgs):
        init_dialogue(dialogue);
    );
    DialogueManager.dialogue_ended.connect(func(dia_resource: DialogueResource):
        if (dia_resource != current_dialogue): return;
        finish_dialogue();
    );

    dialogue_responses.response_selected.connect(func(response: DialogueResponse):
        next_line = response.next_id;
        advance_dialogue();
    );

    button_advance.text = Keybinds.format_action_string(button_advance.text);
    button_skip.text = Keybinds.format_action_string(button_skip.text);
    button_skip_complete.text = Keybinds.format_action_string(button_skip_complete.text);

    button_advance.button_down.connect(Input.action_press.bind("Primary"));
    button_advance.button_up.connect(Input.action_release.bind("Primary"));
    button_skip.button_down.connect(Input.action_press.bind("Secondary"));
    button_skip.button_up.connect(Input.action_release.bind("Secondary"));
    button_skip_complete.button_down.connect(Input.action_press.bind("Tertiary"));
    button_skip_complete.button_up.connect(Input.action_release.bind("Tertiary"));

func _process(delta: float) -> void:
    if (!self.visible): return;
    if (Input.is_action_just_pressed("Primary")):
        advance_dialogue();
    elif (Input.is_action_just_pressed("Secondary")):
        skip_dialogue();
    elif (Input.is_action_pressed("Tertiary")):
        if (current_dialogue && dialogue_label.is_typing): skip_dialogue();
        else: advance_dialogue();
