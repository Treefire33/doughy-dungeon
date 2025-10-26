extends Node

# Three functions:
# Decision -> player has done their turn, applies items.
# Purchased -> player has purchased the item, applies item.
# EnemyKill -> an enemy has died, apply item to enemy.
var load_path: String:
	get: return "res://Sprites/Items/%s.tres";

var all_items = DirAccess.get_files_at("res://Items");

func get_random_item(dungeon_data: DungeonData) -> ItemData:
	var rng = RandomNumberGenerator.new();
	
	var keys = [];
	var weights = [];
	for item in dungeon_data.items:
		keys.append(item);
		weights.append(item.weight);
	
	return keys[rng.rand_weighted(weights)];

func _execute_item_func(function: Script, args: Array) -> bool:
	function.reload();
	var inst = function.new();
	var inst_res = inst.callv("use", args);
	if (inst_res == null):
		push_error("Item function doesn't exist or does not return any value.");
		return false;
	return inst_res;

func execute_item_func(function: Script, ...args: Array) -> bool:
	return _execute_item_func(function, args);

func activate_items(items: Array[ItemData], function: String, ...args: Array) -> void:
	for item in items:
		var result = _execute_item_func(item.get(function), args);
		if (!result):
			return;
		Audio.play_audio(get_node("/root/"), Audio.item_activated);
		ToastParty.show({
			"text": "%s activated!" % item.name,
			"text_size": Settings.toast_size,
			"bgcolor": Color(0, 0, 0, 1),
			"color": Color(1, 1, 1, 1),
			"gravity": "top",
			"direction": "right",
		});
