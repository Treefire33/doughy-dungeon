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
        player.add_item(item);
    room_manager.player_ui.update_ui();

func remove_item(item: String, count: int = 1):
    if (room_manager == null):
        return;
    if (!player.items.get(item)):
        return;
    player.items[item] -= count;
    if (player.items[item] <= 0):
        player.items.erase(item);
    room_manager.player_ui.update_ui();

func set_player_stat(stat_name: String, value: Variant):
    match (stat_name):
        "max_health":
            player._max_health = value;
        "health":
            player.health = value;
        "max_stamina":
            player._max_stamina = value;
        "stamina":
            player.stamina = value;
        "max_defending_duration":
            player._max_defending_duration = value;
        "defending_duration":
            player.defending_duration = value;
        "max_defense_durability":
            player._max_defense_durability = value;
        "defense_durability":
            player.defense_durability = value;
        "attack":
            player._attack = value;
        "coins":
            player.coins = value;
    room_manager.player_ui.update_ui();

var global_player_flags: Array[StringName] = (func():
    var final: Array[StringName] = [];
    for prop in GlobalPlayer.get_property_list():
        final.append(prop["name"]);
    return final;
).call();
func set_player_flag(flag_name: StringName, value: Variant):
    GlobalPlayer.set(flag_name, value);

func add_status_effect(effect: String, turn_count: int):
    if (room_manager == null):
        return;
    StatusEffect.apply_effect(room_manager.player, turn_count, Enum.StatusEffect.get(effect));

func _ready() -> void:
    DebugConsole.add_command("set_room_count", set_room, self, [
        DebugCommand.Parameter.new("room", DebugCommand.ParameterType.Int)
    ]);
    DebugConsole.add_command("add_item", add_item, self, [
        DebugCommand.Parameter.new("item", DebugCommand.ParameterType.Options, ItemUtils.item_database.keys()),
        DebugCommand.Parameter.new("count", DebugCommand.ParameterType.Int)
    ]);
    DebugConsole.add_command("remove_item", remove_item, self, [
        DebugCommand.Parameter.new("item", DebugCommand.ParameterType.Options, ItemUtils.item_database.keys()),
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
    DebugConsole.add_command("set_player_flag", set_player_flag, self, [
        DebugCommand.Parameter.new("stat_name", DebugCommand.ParameterType.Options, global_player_flags),
        DebugCommand.Parameter.new("value", DebugCommand.ParameterType.Bool)
    ]);
    DebugConsole.add_command("add_status_effect", add_status_effect, self, [
        DebugCommand.Parameter.new("effect", DebugCommand.ParameterType.Options, Enum.StatusEffect.keys()),
        DebugCommand.Parameter.new("duration", DebugCommand.ParameterType.Int)
    ]);
    DebugConsole.set_pause_on_open(true);
