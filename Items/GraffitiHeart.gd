extends ItemData

func _init() -> void:
    name = tr("Graffiti Heart");
    flavour_text = tr("Reminds you of a melancholic sunrise...");
    description = tr("Random chance to heal for 50% health.");

    price = 200;
    weight = 1.5;

    sprite = load("res://Sprites/Items/GraffitiHeart.tres");
    function = load("res://Items/Functions/GraffitiHeartFunction.gd");

    unique_stacking = false;
    painful = false;
