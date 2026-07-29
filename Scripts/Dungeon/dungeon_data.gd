extends Resource
class_name DungeonData

@export var id: Enum.Dungeon;
@export var name: String;
@export var enemies: Array[EnemyData] = [];
@export var boss_enemy: EnemyData;
@export var rooms: Array[RoomData] = [];
@export var wall_texture: Texture;
@export var floor_texture: Texture;
@export var dungeon_music: AudioStreamInteractive;

@export_category("Dungeon Info")
@export var room_count: int = 100;
@export var difficulty_floor_increment: int = 1;
@export var rooms_until_next_floor: int = 10;
@export var minimum_difficulty: int = 1;
@export var maximum_difficulty: int = 10;

@export_category("Misc")
@export_multiline var description: String = "";
