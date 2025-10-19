@tool
extends EditorScript
class_name DialogueEditor

var editor_window: Window;

var character_dropdown: OptionButton;
var emotion_dropdown: OptionButton;
var speech_text: TextEdit;
var duration_edit: SpinBox;
var speech_container: VBoxContainer;
var add_speech_button: Button;
var remove_speech_button: Button;
var save_button: Button;

var current_dialogue: DialogueData;
var current_speech: DialogueSpeech;

func exit():
	editor_window.queue_free();

func open_speech(index: int):
	current_speech = current_dialogue.dialogue[index];
	character_dropdown.select(current_speech.character);
	emotion_dropdown.select(current_speech.emotion);
	speech_text.text = current_speech.speech;
	duration_edit.value = current_speech.duration;

func create_dialogue_button(index: int):
	var button = Button.new();
	button.custom_minimum_size = Vector2i(0, 50);
	button.pressed.connect(open_speech.bind(index));
	button.text = str(index);
	speech_container.add_child(button);

func reload_speech_buttons():
	for btn in speech_container.get_children():
		btn.queue_free();

	for i in range(len(current_dialogue.dialogue)):
		create_dialogue_button(i);

func _run() -> void:
	editor_window = Window.new();
	EditorInterface.popup_dialog_centered(editor_window, Vector2i(800, 450));

	var dialogue_editor = load("res://EditorTools/dialogue_tool.tscn").instantiate();
	character_dropdown = dialogue_editor.get_node("FlowContainer/Editor/Basic Info/VBoxContainer/Character/Text");
	character_dropdown.item_selected.connect(func(index: int):
		current_speech.character = index as Enum.Character;
	);
	emotion_dropdown = dialogue_editor.get_node("FlowContainer/Editor/Basic Info/VBoxContainer/Emotion/Text");
	emotion_dropdown.item_selected.connect(func(index: int):
		current_speech.emotion = index as Enum.DialogueEmotion;	
	)
	speech_text = dialogue_editor.get_node("FlowContainer/Editor/Basic Info/VBoxContainer/LineText/Text");
	speech_text.text_changed.connect(func():
		current_speech.speech = speech_text.text;
	);
	duration_edit = dialogue_editor.get_node("FlowContainer/Editor/Basic Info/VBoxContainer/Duration/Text");
	duration_edit.value_changed.connect(func(value: float):
		current_speech.duration = value;
	);
	speech_container = dialogue_editor.get_node("FlowContainer/Viewer/DialogueSpeeches/SpeechContainer");
	add_speech_button = dialogue_editor.get_node("FlowContainer/Viewer/AddSpeech");
	add_speech_button.pressed.connect(func():
		current_dialogue.dialogue.append(DialogueSpeech.new());
		reload_speech_buttons();
	)
	remove_speech_button = dialogue_editor.get_node("FlowContainer/Viewer/RemoveSpeech");
	remove_speech_button.pressed.connect(func():
		if (len(current_dialogue.dialogue) - 1 <= 0):
			return;
		var index = current_dialogue.dialogue.find(current_speech);
		current_dialogue.dialogue.remove_at(index);
		open_speech(index-1);
		reload_speech_buttons();
	);
	save_button = dialogue_editor.get_node("FlowContainer/Viewer/Save");
	save_button.pressed.connect(func():
		ResourceSaver.save(current_dialogue);
	);

	for i in Enum.Character.values():
		i = i as Enum.Character;
		character_dropdown.add_item(Enum.Character.keys()[i], i);
	character_dropdown.select(0);

	for i in Enum.DialogueEmotion.values():
		i = i as Enum.DialogueEmotion;
		emotion_dropdown.add_item(Enum.DialogueEmotion.keys()[i], i);
	emotion_dropdown.select(0);

	reload_speech_buttons();

	open_speech(0);

	editor_window.add_child(dialogue_editor);

	editor_window.close_requested.connect(func():
		exit();
	);
