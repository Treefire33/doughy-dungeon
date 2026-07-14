extends ItemData

func _init() -> void:
    name = tr("Golden Heart");
    flavour_text = tr("Feeling like pure- AU! My heart...");
    description = tr("Your health scales with the amount of coins you have.");

    price = 237;
    weight = 2.0;

    sprite = load("res://Sprites/Items/GoldenHeart.tres");
    function = load("res://Items/Functions/GoldenHeartFunction.gd");

    unique_stacking = true;
    painful = false;
