extends Resource
class_name RPGItemData

@export var item_type: Enum.RPGItemType;
@export var name: String;
@export_multiline() var description: String;
@export var icon_override: Texture2D;
@export var overworld_cloak: SpriteFrames;
@export var dungeon_cloak: SpriteFrames;

@export var max_health: int;
@export var max_stamina: int;
@export var attack: int;
@export var max_defense_duration: int;
@export var max_defense_durability: int;
@export var speed: int;
