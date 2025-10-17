extends Resource
class_name DungeonData

@export var name: String;
@export var enemies: Array[EnemyData] = [];
@export var items: Array[ItemData] = [];
@export var wall_texture: Texture;
@export var floor_texture: Texture;

@export_category("Dungeon Info")
@export_range(10, 500) var room_count: int = 100;
@export var difficulty_floor_increment: int = 1;
@export var rooms_until_next_floor: int = 10;
@export var minimum_difficulty: int = 1;
@export var maximum_difficulty: int = 10;
