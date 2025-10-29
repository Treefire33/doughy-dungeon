extends Node

enum Decision {
	Attack = 0,
	Defend = 1,
	Rest = 2
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
	Vendor = 1
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
	Left = 0, Up = 1,
	Down = 2, Right = 3
}

enum DungeonID {
	Alcove, Oceanic, Doughy, Magamatic, Abyssal,
	CliffSide, TrueAbyss
}
