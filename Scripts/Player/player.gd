extends Entity
class_name Player

signal player_ready;

@onready var shield: Sprite2D = $Shield;

var coins: int = 15:
	get: return coins;
	set(value):
		ItemUtils.activate_items(self, "stat_changed", self, "coins");
		coins = value;
		
var items: Dictionary[String, int] = {};

func add_item(item_name: String):
	if (!items.get(item_name)):
		items[item_name] = 0;
	
	items[item_name] += 1;
	for item in items:
		var count: int = items[item];
		var data: ItemData = ItemUtils.get_item_data(item);
		if (data.function == null): continue;
		ItemUtils._execute_item_func(data.function, "purchased", [self, item_name == item, count]);

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
	load_entity(15, 12, 2, $Sprite, $Animator);
	play_anim(Enum.PlayerAnimation.Idle);
	durability_changed.connect(func():
		shield.frame = 0;
		if (defense_durability == 0):
			shield.frame = 1;
	)
	player_ready.emit();
