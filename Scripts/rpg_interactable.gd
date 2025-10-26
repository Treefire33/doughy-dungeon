extends Node
class_name RPGInteractable
@export var opens_dungeon: bool = false;
@export var dungeon: DungeonData;
@export var dialogue: DialogueData;

func _ready() -> void:
    if (dungeon != null):
        if (GlobalPlayer.completed_dungeons[dungeon.id] == true):
            queue_free();