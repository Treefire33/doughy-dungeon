extends Node

# Three functions:
# Decision -> player has done their turn, applies items.
# Purchased -> player has purchased the item, applies item.
# EnemyKill -> an enemy has died, apply item to enemy.
var load_path: String:
	get: return "res://Sprites/Items/%s.tres";

var all_items: Array[String] = [
	"SharpeningStone", "BluePotion", "RedPotion",
	"Pillow", "GoldAmulet", "LooseFang",
	"PeaceCharm", "Whisk", "OvenMitt",
	"Coffee", "DurabilityScroll",
	"AbyssFragment", "AbyssHeart"
];

func get_random_item(dungeon_data: DungeonData) -> ItemData:
	var rng = RandomNumberGenerator.new();
	
	var keys = [];
	var weights = [];
	for item in dungeon_data.items:
		keys.append(item);
		weights.append(item.weight);
	
	return keys[rng.rand_weighted(weights)];

func execute_item_func(function: Script, ...args: Array) -> bool:
	function.reload();
	var inst = function.new();
	var inst_res = inst.callv("use", args);
	if (inst_res == null):
		push_error("Item function doesn't exist or does not return any value.");
		return false;
	return inst_res;
