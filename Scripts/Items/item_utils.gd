extends Node

var load_path: String:
	get: return "res://Items/%s.tres";

var all_items = DirAccess.get_files_at("res://Items");

func get_random_item(dungeon_data: DungeonData) -> ItemData:
	var rng = RandomNumberGenerator.new();
	
	var keys = [];
	var weights = [];
	for item in dungeon_data.items:
		keys.append(item);
		weights.append(item.weight);
	
	return keys[rng.rand_weighted(weights)];

func get_item_data(item_name: String) -> ItemData:
	return load(load_path % item_name);

func show_activation_toast(item: String):
	ToastParty.show({
		"text": "%s activated!" % item,
		"text_size": Settings.toast_size,
		"bgcolor": Color(0, 0, 0, 1),
		"color": Color(1, 1, 1, 1),
		"gravity": "bottom",
		"direction": "right",
	});
	Audio.play_audio(Audio.item_activated);

func show_custom_toast(item: String):
	ToastParty.show({
		"text": item,
		"text_size": Settings.toast_size,
		"bgcolor": Color(0, 0, 0, 1),
		"color": Color(1, 1, 1, 1),
		"gravity": "bottom",
		"direction": "right",
	});
	Audio.play_audio(Audio.item_activated);

func _execute_item_func(function: Script, func_name: String, args: Array) -> void:
	var inst: Resource = function.new();
	var _inst_res = inst.callv(func_name, args);

func activate_items(player: Player, function: String, ...args: Array) -> void:
	for item in player.items:
		var count: int = player.items[item];
		var data: ItemData = get_item_data(item);
		if (data == null):
			push_error("Item %s failed to retrieve its item data." % item);
			continue;
		if (data.function == null): continue;
		if (data.unique_stacking):
			_execute_item_func(data.function, function, args + [count]);
		else:
			for i in range(count):
				_execute_item_func(data.function, function, args + [count]);

func _ready() -> void:
	for i in range(len(all_items)):
		all_items[i] = all_items[i].left(-5);
