extends ItemData

func _init() -> void:
    name = tr("Peace Charm");
    flavour_text = tr("A symbol of peace used by many guilds. Soothing.");
    description = tr("On defend or rest, 40% chance to regen 40% health.");

    price = 125;
    weight = 6.0;

    sprite = load("res://Sprites/Items/PeaceCharm.tres");
    function = load("res://Items/Functions/PeaceCharmFunction.gd");

    unique_stacking = false;
    painful = false;
