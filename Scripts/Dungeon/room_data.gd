extends Resource
class_name RoomData

@export var room_name: String = "";
@export_multiline() var room_description: String = "";
@export var room_character: String = "+";
@export var room_type: Enum.RoomDecision = Enum.RoomDecision.Proceed;
@export var room_length: int = 1;

@export var room_weight: float = 1.0;
@export var minimum_difficulty: int = 1;
@export var maximum_difficulty: int = 30;
@export var enemies: Array[EnemyData] = [];

static var default_rooms: Array[RoomData] = [
    load("res://Dungeons/Rooms/StandardProceed.tres"),
    load("res://Dungeons/Rooms/StandardRiskIt.tres"),
    load("res://Dungeons/Rooms/StandardStayClear.tres"),
];
