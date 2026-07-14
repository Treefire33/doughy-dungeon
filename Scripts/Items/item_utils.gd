extends Node

var all_items: Dictionary[String, ItemData] = (
    func():
        var item_list: Dictionary[String, ItemData] = {};
        for item in DirAccess.get_files_at("res://Items"):
            var parts = item.split('.');
            if (parts[1] != "gd" || parts.size() > 2): continue;
            item_list[parts[0]] = (load("res://Items/%s" % item) as GDScript).new();
        return item_list;
).call();

func get_random_item(dungeon_data: DungeonData, painful: bool = false) -> String:
    var rng = RandomNumberGenerator.new();
    
    var keys = [];
    var weights = [];
    for item in dungeon_data.items:
        var item_data: ItemData = get_item_data(item);
        if (painful != item_data.painful):
            continue;
        keys.append(item);
        weights.append(item_data.weight);
    
    return keys[rng.rand_weighted(weights)];

func get_item_name(item_data: ItemData) -> String:
    return all_items.find_key(item_data);

func get_item_data(item_name: String) -> ItemData:
    return all_items[item_name];

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

func get_tooltip_text(item_data: ItemData, shop_item: bool) -> String:
    var res: String = "";
    res = item_data.name + "\n[s=8]" + item_data.flavour_text;
    if (shop_item):
        if (!item_data.painful):
            res += "\n\n" + "Price: %d coins" % item_data.price;
        else:
            res += "\n\n" + "Reward: %d coins" % -item_data.price;
    for line in item_data.description.split('\n'):
        res += "\n[s=8]" + line;
    return res;

func decision_is_attack(decision: Enum.Decision) -> bool:
    return decision == Enum.Decision.Attack || decision == Enum.Decision.AttackHeavy || decision == Enum.Decision.SpellAttack;

func decision_is_spell(decision: Enum.Decision) -> bool:
    return decision == Enum.Decision.SpellDefend || decision == Enum.Decision.SpellRetype || decision == Enum.Decision.SpellAttack;

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
            _execute_item_func(data.function, function, args + [RoomManager.instance, count]);
        else:
            for i in range(count):
                _execute_item_func(data.function, function, args + [RoomManager.instance, count]);
