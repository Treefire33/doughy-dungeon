extends Node

# Three functions:
# Decision -> player has done their turn, applies items.
# Purchased -> player has purchased the item, applies item.
# EnemyKill -> an enemy has died, apply item to enemy.
var load_path: String:
	get: return "res://Sprites/Items/%s.tres";
var items = {
	"SharpeningStone": {
		"Name": "Sharpening Stone",
		"Weight": 10,
		"FlavourText": "How do you sharpen a wooden sword?",
		"Description": "On attack, 25% chance to deal damage again.",
		"Price": 50,
		"Sprite": load(load_path % "SharpeningStone"),
		"Decision": func(player: Player, target, decision: Enum.Decision) -> bool:
			if (target == null): return false;;
			if (decision != Enum.Decision.Attack): return false;;
			if (target.defending_duration != 0): return false;;
			if (randi_range(0, 100) <= 25):
				Audio.play_audio(get_node("/root/"), Audio.item_activated);
				target.health -= player.attack;
				return true;
			return false;,
	},
	"BluePotion": {
		"Name": "Blue Potion",
		"Weight": 8,
		"FlavourText": "Refreshing!",
		"Description": "Defending lasts for +1 turn.",
		"Price": 75,
		"Sprite": load(load_path % "BluePotion"),
		"Purchased": func(player: Player) -> void:
			Audio.play_audio(get_node("/root/"), Audio.item_activated);
			player.max_defending_duration += 1;,
	},
	"RedPotion": {
		"Name": "Red Potion",
		"FlavourText": "Healthy!",
		"Weight": 7,
		"Price": 50,
		"Sprite": load(load_path % "RedPotion"),
		"Description": "Increases max health by 2.",
		"Purchased": func(player: Player) -> void:
			Audio.play_audio(get_node("/root/"), Audio.item_activated);
			player.max_health += 2;,
	},
	"Pillow": {
		"Name": "Pillow",
		"FlavourText": "Comfy.",
		"Description": "Resting recovers more stamina.",
		"Price": 50,
		"Weight": 9,
		"Sprite": load(load_path % "Pillow"),
		"Decision": func(player: Player, target, decision: Enum.Decision) -> bool:
			if (decision != Enum.Decision.Rest): return false;
			Audio.play_audio(get_node("/root/"), Audio.item_activated);
			player.stamina += 1;
			return true;,
	},
	"GoldAmulet": {
		"Name": "Gold Amulet",
		"FlavourText": "A strange amulet made of pure gold.",
		"Description": "Enemies drop more gold.",
		"Price": 175,
		"Weight": 3,
		"Sprite": load(load_path % "GoldAmulet"),
		"EnemyKill": func(player: Player, enemy: Enemy) -> void:
			enemy.coin_drop_range = [enemy.coin_drop_range[0] + 5, enemy.coin_drop_range[1] + 10];,
	},
	"LooseFang": {
		"Name": "Loose Fang",
		"FlavourText": "Must've come from one of the biscuit mimics.",
		"Description": "On attack, 10% chance to siphon health.",
		"Price": 135,
		"Weight": 5,
		"Sprite": load(load_path % "LooseFang"),
		"Decision": func(player: Player, target, decision: Enum.Decision) -> bool:
			if (target == null): return false;
			if (decision != Enum.Decision.Attack): return false;
			if (target.defending_duration != 0): return false;
			if (randi_range(0, 100) <= 10):
				Audio.play_audio(get_node("/root/"), Audio.item_activated);
				player.health += player.attack;
				return true;
			return false;,
	},
	"PeaceCharm": {
		"Name": "Peace Charm",
		"FlavourText": "It's strangely soothing.",
		"Description": "On defend or rest, 40% chance to regen 40% health.",
		"Price": 125,
		"Weight": 6,
		"Sprite": load(load_path % "PeaceCharm"),
		"Decision": func(player: Player, target, decision: Enum.Decision) -> bool:
			if (decision == Enum.Decision.Attack): return false;
			if (randi_range(0, 100) <= 40):
				Audio.play_audio(get_node("/root/"), Audio.item_activated);
				player.health += int(player.max_health * 0.4);
				return true;
			return false;,
	},
	"Whisk": {
		"Name": "Whisk",
		"FlavourText": "Shaking things up!",
		"Description": "On attack, damage is randomized between\nbase attack and 50% of max health.",
		"Price": 250,
		"Weight": 1,
		"Sprite": load(load_path % "Whisk"),
		"Decision": func(player: Player, target, decision: Enum.Decision) -> bool:
			if (decision != Enum.Decision.Attack): return false;
			target.health += player.attack;
			target.health -= randi_range(player.attack, player.max_health / 2);
			return true;,
	},
	"OvenMitt": {
		"Name": "Oven Mitt",
		"FlavourText": "Hot-hot-hot- HOT!",
		"Description": "Each room completed adds +1 to difficulty\nand +0.1x to multiplier.\nResets when staying clear.",
		"Price": 250,
		"Weight": 1,
		"Sprite": load(load_path % "OvenMitt"),
		"RoomDecision": func(room_manager: RoomManager, decision: Enum.RoomDecision) -> bool:
			if (decision == Enum.RoomDecision.StayClear):
				room_manager.streak_difficulty = 0;
				room_manager.streak_multiplier = 0;
				Audio.play_audio(get_node("/root/"), Audio.hit_sfx);
				ToastParty.show({
					"text": "Oven Mitt streak reset!",
					"text_size": Settings.toast_size,
					"bgcolor": Color(0, 0, 0, 1),
					"color": Color(1, 1, 1, 1),
					"gravity": "top",
					"direction": "right",
				})
				return false
			else:
				room_manager.streak_difficulty += 1;
				room_manager.streak_multiplier += 0.1;
				ToastParty.show({
					"text": "Oven Mitt streak increased!",
					"text_size": Settings.toast_size,
					"bgcolor": Color(0, 0, 0, 1),
					"color": Color(1, 1, 1, 1),
					"gravity": "top",
					"direction": "right",
				})
			return true;,
	},
	"Coffee": {
		"Name": "Coffee",
		"FlavourText": "A much needed kickstart.",
		"Description": "Stamina won't drain.",
		"Price": 300,
		"Weight": 0.2,
		"Sprite": load(load_path % "Coffee"),
		"Decision": func(player: Player, target, decision: Enum.Decision) -> bool:
			player.stamina = player.max_stamina;
			return true;,
	},
	"DurabilityScroll": {
		"Name": "Durability Scroll",
		"FlavourText": "A scroll containing arcane instructions.",
		"Description": "Increases Shield Spell durability by 1.",
		"Price": 125,
		"Weight": 5,
		"Sprite": load(load_path % "DurabilityScroll"),
		"Purchased": func(player: Player) -> void:
			Audio.play_audio(get_node("/root/"), Audio.item_activated);
			player.max_defense_durability += 1;,
	}
}

func get_random_item():
	var rng = RandomNumberGenerator.new();
	
	var keys = [];
	var weights = [];
	for item in self.items:
		keys.append(item)
		weights.append(self.items[item]["Weight"])
	
	return keys[rng.rand_weighted(weights)]
