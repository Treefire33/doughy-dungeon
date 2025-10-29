extends RPGInteractable
class_name RPGDungeon

@export var dungeon: DungeonData;

func _ready() -> void:
    if (dungeon.id == Enum.DungeonID.Abyssal && GlobalPlayer.has_abyss_heart):
        dungeon = load("res://Dungeons/TrueAbyss.tres");
