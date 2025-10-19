extends Resource
class_name DialogueSpeech

@export var character: Enum.Character = Enum.Character.Midnight;
@export var emotion: Enum.DialogueEmotion = Enum.DialogueEmotion.Neutral;
@export var speech: String = "";
@export var dialogue_event: bool = false;
@export var event_args: Array[String] = [];
@export var duration: float = 0.3;
