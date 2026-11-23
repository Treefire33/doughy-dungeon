extends Resource
class_name EnemyData

@export var name: String = "Enemy";
@export_multiline var flavour_text: String = "Flavour";
		
@export var base_health: int = 10;
@export var base_stamina: int = 5;
@export var base_attack: int = 1;
@export var base_defense_duration: int = 1;
@export var base_defense_durability: int = 1;

@export var sprite: StringName = &"Nil";
@export var boss: bool = false;

@export_enum(
	"Default", "Random", 
	"Aggressive","Attack", 
	"Defensive", "Defend", 
	"Restless", "Rest", 
	"Smart"
)
var base_ai: String = "Default":
	set (value):
		base_ai = value;

@export_enum(
	"Default", "Random", 
	"Aggressive","Attack", 
	"Defensive", "Defend", 
	"Restless", "Rest", 
	"Smart"
) var base_ai_five: String = "Default":
	set (value):
		base_ai_five = value;

@export_enum(
	"Player", "Random", "Target"
) var target_selection_ai: String = "Player":
	set (value):
		target_selection_ai = value;

@export_range(-5, 5) var speed: int = 1;
@export_range(1, 20) var difficulty_range: Array[int] = []; 
@export_range(1, 1000) var coins_range: Array[int] = [];
