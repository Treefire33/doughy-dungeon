extends ItemData

func _init() -> void:
    name = tr("Dagger Heart");
    flavour_text = tr("If you're willing to bear the pain...");
    description = tr("Halve your health and double your damage  (Applied once on purchase).");

    price = 450;
    weight = 1.0;

    sprite = load("res://Sprites/Items/DaggerHeart.tres");
    function = load("res://Items/Functions/DaggerHeartFunction.gd");

    unique_stacking = false;
    painful = false;
