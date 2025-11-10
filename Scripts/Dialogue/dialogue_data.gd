@tool
extends Resource
class_name DialogueData

@export_tool_button("Open Editor", "Window") var editor_action = open_editor;
@export var dialogue: Array[DialogueSpeech] = [];

func open_editor():
    var dialogue_editor = DialogueEditor.new();
    dialogue_editor.current_dialogue = load(self.resource_path);
    dialogue_editor._run();

static var character_icons: Dictionary[Enum.Character, AtlasTexture] = {
    Enum.Character.Midnight: preload("res://Sprites/Dialogue/midnight_dialogue.tres"),
    Enum.Character.Vendor: preload("res://Sprites/Dialogue/vendor_dialogue.tres"),
    Enum.Character.TripDawg: preload("res://Sprites/Dialogue/tripdawg.tres")
};

static func get_character_icon(character: Enum.Character, emotion: Enum.DialogueEmotion):
    var icons = character_icons[character];
    icons.region = Rect2i(emotion * 64, icons.region.position.y, 64, 64);
    return icons;
