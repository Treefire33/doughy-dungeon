extends Node

enum Decision {
	Attack,
	AttackHeavy,
	Spell,
	SpellTwo,	
	SpellThree,
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
	Idle,
	Attack,
	Defend,
	Rest,
	Dead,
	Spell,
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

	RoomDifficulty, RoomMultiplier,

	Rerolls
}

enum StatusEffect {
    Burn, Poison, Stun, Influence,
	Tired, Sadness, Bravery, Exhausted,
	Crystallized, Wet
}

enum RPGItemType {
	Cloak, Sword, Spell
}

enum SpellSpecification {
	None, Attack, Defend, Activate, Special
}

enum ItemRarity {
	None, # items that shouldn't be rolled (abyss heart).
	NoneTwo, # whoops
	Common, # base items (sharpening stone, urchin, the potions).
	Uncommon, # items that are a bit less common and are stronger as a result (ivory key, etc).
	Rare, # items that provide a strong buff and should be a lot rarer as a result (dagger heart, golden heart, etc).
	Abyssal, # items relating to the abyss (abyss fragment).
	Curio # items that are quite interesting (cloutium pipe, nail, monowire), rarest category, but doesn't guarantee strength.
}
