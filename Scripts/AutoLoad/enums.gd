extends Node

enum Decision {
	Attack,
	AttackHeavy,
	Spell,
	SpellSlotOne,	
	SpellSlotTwo,
	SpellEnemyDefend,
	Rest
};

enum RoomDecision {
	Proceed = 0,
	RiskIt = 1,
	StayClear = 2,
	NextBiome = 3,
	Boss = 4
}

enum PlayerAnimation {
	Idle = 0,
	Attack = 1,
	Defend = 2,
	Rest = 3,
	Dead = 4
}

enum Character {
	None,
	Midnight,
	Vendor,
	TripDawg,
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

enum Dungeon {
	All = -1, # Item pools
	Alcove, Oceanic, Doughy, Magamatic, Abyssal, # Base-game dungeons
	HavenOne, HavenTwo, HavenThree, # Havens
	CliffSide, TrueAbyss, # True ending dungeons
	TrueAlcove,

	ErrorEntity
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
	Speed,

	RoomDifficulty, RoomMultiplier
}

enum StatusEffect {
    Burn, Poison, Stun, Influence,
	Tired, Sadness, Bravery, Exhausted,
	Crystallized, Wet
}

enum RPGItemType {
	Cloak, Sword, ShieldSpell, Spell
}

enum SpellSpecification {
	None, Attack, Defend, Activate
}
