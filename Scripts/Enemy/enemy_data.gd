extends Resource
class_name EnemyData

@export var name: String = "Enemy":
	set (value):
		name = value;

@export_multiline var flavour_text: String = "Flavour":
	set (value):
		flavour_text = value;
		
@export var base_health: int = 10:
	set (value):
		base_health = value;

@export var base_stamina: int = 5:
	set (value):
		base_stamina = value;

@export var base_attack: int = 1:
	set (value):
		base_attack = value;

@export var base_defense_duration: int = 1:
	set (value):
		base_defense_duration = value;

@export var base_defense_durability: int = 1:
	set (value):
		base_defense_durability = value;

@export var sprite: Texture2D = null:
	set (value):
		sprite = value;

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

@export_range(1, 10) var difficulty_range: Array[int] = []; 
@export_range(1, 1000) var coins_range: Array[int] = [];
