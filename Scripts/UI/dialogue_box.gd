extends Control
class_name DialogueBox

signal start_dialogue(dialogue: DialogueData);
signal dialogue_finished();

@onready var icon: TextureRect = $IconRect;
@onready var dialogue_label: RichTextLabel = $Dialogue;

var current_dialogue: DialogueData;
var current_speech: int = 0;
var doing_dialogue: bool = false;
var speech_finished: bool = false;

func typewriter(duration: float):
	for i in range(dialogue_label.get_total_character_count() + 1):
		dialogue_label.visible_characters = i;
		await get_tree().create_timer(duration / dialogue_label.get_total_character_count()).timeout;
	speech_finished = true;

func init_dialogue(dialogue: DialogueData):
	doing_dialogue = true;
	dialogue_label.visible_characters = 0;
	current_dialogue = dialogue;
	current_speech = 0;
	var current_speech_data = dialogue.dialogue[current_speech];
	dialogue_label.text = current_speech_data.speech;
	icon.texture = DialogueData.get_character_icon(current_speech_data.character, current_speech_data.emotion);
	typewriter(current_speech_data.duration);

func advance_dialogue():
	current_speech += 1;
	speech_finished = false;
	if (current_speech >= len(current_dialogue.dialogue)):
		dialogue_finished.emit();
		self.visible = false;
		return;
	var current_speech_data = current_dialogue.dialogue[current_speech];
	dialogue_label.text = current_speech_data.speech;
	icon.texture = DialogueData.get_character_icon(current_speech_data.character, current_speech_data.emotion);
	typewriter(current_speech_data.duration);

func _input(event: InputEvent):
	if (!doing_dialogue): return;
	if (Input.is_action_just_pressed("Primary")):
		if (!dialogue_finished): return;
		advance_dialogue();

# func _ready() -> void:
# 	init_dialogue(load("res://Dialogue/vendor_intro.tres"));

func _on_start_dialogue(dialogue: DialogueData) -> void:
	self.visible = true;
	init_dialogue(dialogue);
