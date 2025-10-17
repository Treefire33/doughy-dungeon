extends Entity
class_name Player

signal player_ready;

@onready var animator: AnimationPlayer = $Animation;
@onready var shield: Sprite2D = $Shield;

var coins: int = 15:
	get: return coins;
	set(value):
		coins = value;
		
var items: Array[ItemData] = [];

func get_items(has_function: String = "") -> Array[ItemData]:
	var final: Array[ItemData] = [];
	for item in self.items:
		if (item.get(has_function) == null && has_function != ""): continue;
		final.append(item);
	return final;

func get_item_count(specific_item: String):
	var item_count = {}
	for item in items:
		item_count.get_or_add(item.name, 0);
		item_count[item.name] += 1;
	
	return item_count.get(specific_item, 0);

var player_animation_to_name = {
	Enum.PlayerAnimation.Idle: "Player/Idle",
	Enum.PlayerAnimation.Attack: "Player/Attack",
	Enum.PlayerAnimation.Defend: "Player/Defend",
	Enum.PlayerAnimation.Rest: "Player/Rest",
	Enum.PlayerAnimation.Dead: "Player/Dead"
};
func play_anim(decision: Enum.PlayerAnimation):
	# animator.speed_scale = Settings.game_speed;
	animator.play(player_animation_to_name[decision]);

func update_shield():
	shield.visible = defense_durability != 0 && defending_duration != 0
			
func _ready():
	load_entity(15, 12, 2, $Sprite);
	play_anim(Enum.PlayerAnimation.Idle);
	durability_changed.connect(func():
		shield.frame = 0;
		if (defense_durability == 0):
			shield.frame = 1;
	)
	player_ready.emit();
