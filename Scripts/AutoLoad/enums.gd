extends Node

enum Decision {
	Attack,
	AttackHeavy,
	Spell,
	SpellDefend,	
	SpellAttack,
	SpellRetype,
	Rest
};

enum RoomDecision {
	Proceed = 0,
	RiskIt = 1,
	StayClear = 2,
	NextBiome = 3,
}

enum PlayerAnimation {
	Idle = 0,
	Attack = 1,
	Defend = 2,
	Rest = 3,
	Dead = 4
}

enum Character {
	Midnight = 0,
	Vendor = 1,
	TripDawg = 100,
}

enum DialogueEmotion {
	Neutral,
	Surprise,
	Confusion,
	Happy,
	Tired,
	Disappointed
}

enum Direction {
	None = -1,
	Left = 0, Up = 1,
	Down = 2, Right = 3
}

enum DungeonID {
	Alcove, Oceanic, Doughy, Magamatic, Abyssal,
	CliffSide, TrueAbyss
}

enum RPGItem {
	Cloak,
	Sword,
	ShieldSpell,
	Endurance
}

enum ModifierType {
	Preset,
    Additive,
    Multiplicative,
    Exponential,
    Set
}

enum StatType {
    MaxHealth, MaxStamina,
    Attack, MaxDuration, MaxDurability,
	Speed
}

class Upgrades:
	enum Cloaks {
		Tattered, GuildApprentice, GuildMember, GuildMaster, BeetleWing,
		Restitched
	}

	enum Swords {
		Wood, Bronze, Iron, Cobalt
	}

	enum Shields {
		Standard, StandardTwo, 
		AzureOne, AzureTwo,
		CobaltOne, CobaltTwo, CobaltThree,
		Clasp
	}

	static var cloak_data = {
		Cloaks.Tattered: {
			"Name": "Tattered Cloak",
			"Description": "A gift from mom.",

			"Health": 15,
			"Stamina": 12
		},
		Cloaks.GuildApprentice: {
			"Name": "Guild Cloak",
			"Description": "Standard issue guild cloak from the Guild of Priorites.",

			"Health": 20,
			"Stamina": 15
		},
		Cloaks.GuildMember: {
			"Name": "Guild Cloak",
			"Description": "Standard issue guild cloak from the Guild of Priorites.",

			"Health": 35,
			"Stamina": 20
		},
		Cloaks.GuildMaster: {
			"Name": "Guild Cloak",
			"Description": "Standard issue guild cloak from the Guild of Priorites.",

			"Health": 45,
			"Stamina": 30
		},
		Cloaks.BeetleWing: {
			"Name": "Beetle-Wing Cloak",
			"Description": "Wings gathered from the carapace of a long extinct beetle beast. A gift from the Vendor.",

			"Health": 50,
			"Stamina": 40
		},
		Cloaks.Restitched: {
			"Name": "Restitched Cloak",
			"Description": "A gift from the guild's tailor.",

			"Health": 30,
			"Stamina": 25
		}
	};

	static var sword_data = {
		Swords.Wood: {
			"Name": "Wood Sword",
			"Description": "A wooden sword. Very light and blunt.",

			"Attack": 1
		},
		Swords.Bronze: {
			"Name": "Bronze Sword",
			"Description": "A bronzen sword. While still light, it has a sharper edge.",

			"Attack": 4
		},
		Swords.Iron: {
			"Name": "Iron Sword",
			"Description": "An iron sword. Heavy and deadly.",

			"Attack": 7
		},
		Swords.Cobalt: {
			"Name": "Cobalt Sword",
			"Description": "A cobalt(?) sword. Constructed from shield spells.",

			"Attack": 10
		},
	};

	static var shield_data = {
		Shields.Standard: {
			"Name": "Shield Spell",
			"Description": "A simple spell taught to all, creates a shield around the user.",

			"DefenseDuration": 1,
			"DefenseDurability": 1
		},
		Shields.StandardTwo: {
			"Name": "Shield Spell II",
			"Description": "A slightly more complex variation of the shield spell. Last longer and is stronger.",

			"DefenseDuration": 3,
			"DefenseDurability": 4
		},
		Shields.AzureOne: {
			"Name": "Azure Spell I",
			"Description": "A specialized version of the shield spell that focuses on duration over durability.",

			"DefenseDuration": 5,
			"DefenseDurability": 2
		},
		Shields.AzureTwo: {
			"Name": "Azure Spell II",
			"Description": "A stronger version of the Azure Spell.",

			"DefenseDuration": 10,
			"DefenseDurability": 4
		},
		Shields.CobaltOne: {
			"Name": "Cobalt Spell I",
			"Description": "A specialized version of the shield spell that focuses on durability over duration.",

			"DefenseDuration": 2,
			"DefenseDurability": 5
		},
		Shields.CobaltTwo: {
			"Name": "Cobalt Spell II",
			"Description": "A stronger version of the Cobalt Spell.",

			"DefenseDuration": 4,
			"DefenseDurability": 8
		},
		Shields.CobaltThree: {
			"Name": "Cobalt Spell III",
			"Description": "The strongest version of the Cobalt Spell.",

			"DefenseDuration": 5,
			"DefenseDurability": 12
		},
		Shields.Clasp: {
			"Name": "Clasping Spell",
			"Description": "Strongest and longest lasting shield spell.",

			"DefenseDuration": 15,
			"DefenseDurability": 20
		},
	}
