extends Control
class_name DialogueBox

signal start_dialogue(dialogue: DialogueData);
signal dialogue_finished();

@onready var icon: TextureRect = $IconRect;
@onready var dialogue_label: RichTextLabel = $Dialogue;

var current_dialogue: DialogueData;
var current_speech: int = 0;
var speech_finished: bool = false;

func typewriter(duration: float):
	for i in range(dialogue_label.get_total_character_count() + 1):
		if (speech_finished): break;
		dialogue_label.visible_characters = i;
		await get_tree().create_timer(duration / 20).timeout;
	speech_finished = true;

func init_dialogue(dialogue: DialogueData):
	dialogue_label.visible_characters = 0;
	current_dialogue = dialogue;
	current_speech = -1;
	speech_finished = true;
	advance_dialogue();

func advance_dialogue():
	if (!speech_finished):
		return;
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

func skip_dialogue():
	speech_finished = true;
	dialogue_label.visible_characters = dialogue_label.get_total_character_count();

func _ready() -> void:
	start_dialogue.connect(
		func(dialogue: DialogueData):
			self.visible = true;
			init_dialogue(dialogue);
	);
