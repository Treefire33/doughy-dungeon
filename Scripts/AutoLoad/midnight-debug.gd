extends Node

var room_manager: RoomManager = null;
var player: Player = null;

func set_room(count: int):
	if (room_manager == null):
		return;
	room_manager.room_count = count;
	room_manager.player_ui.update_ui();

func add_item(item: String, count: int = 1):
	if (room_manager == null):
		return;
	for i in range(count):
		player.items.append(item);
		if ItemData.items[item].has("Purchased"):
			ItemData.items[item]["Purchased"].call(player);

func remove_item(item: String, count: int = 1):
	if (room_manager == null):
		return;
	for i in range(count):
		player.items.erase(item);

func set_player_stat(stat_name: String, value: Variant):
	match (stat_name):
		"max_health":
			player.max_health = value;
		"health":
			player.health = value;
		"max_stamina":
			player.max_stamina = value;
		"stamina":
			player.stamina = value;
		"max_defending_duration":
			player.max_defending_duration = value;
		"defending_duration":
			player.defending_duration = value;
		"max_defense_durability":
			player.max_defense_durability = value;
		"defense_durability":
			player.defense_durability = value;
		"attack":
			player.attack = value;
		"coins":
			player.coins = value;
	room_manager.player_ui.update_ui();

func _ready() -> void:
	DebugConsole.add_command("set_room_count", set_room, self, [
		DebugCommand.Parameter.new("room", DebugCommand.ParameterType.Int)
	]);
	DebugConsole.add_command("add_item", add_item, self, [
		DebugCommand.Parameter.new("item", DebugCommand.ParameterType.Options, ItemData.items.keys()),
		DebugCommand.Parameter.new("count", DebugCommand.ParameterType.Int)
	]);
	DebugConsole.add_command("remove_item", remove_item, self, [
		DebugCommand.Parameter.new("item", DebugCommand.ParameterType.Options, ItemData.items.keys()),
		DebugCommand.Parameter.new("count", DebugCommand.ParameterType.Int)
	]);
	DebugConsole.add_command("set_player_stat", set_player_stat, self, [
		DebugCommand.Parameter.new("stat_name", DebugCommand.ParameterType.Options, [
			"max_health", "health", "max_stamnia", "stamina", "attack",
			"max_defending_duration", "defending_duration", "max_defense_durability", "defense_durability",
			"coins"
		]),
		DebugCommand.Parameter.new("value", DebugCommand.ParameterType.Float)
	]);
	DebugConsole.set_pause_on_open(true);
