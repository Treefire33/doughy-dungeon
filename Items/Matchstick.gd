extends ItemData

func _init() -> void:
    name = tr("Matchstick");
    flavour_text = tr("I don't want to light this...");
    description = tr("Defending now applies one stack of burn.");

    price = -75;
    weight = 10.0;

    sprite = load("res://Sprites/Items/Matchstick.tres");
    function = load("res://Items/PainfulFunctions/MatchstickFunction.gd");

    unique_stacking = true;
    painful = true;
