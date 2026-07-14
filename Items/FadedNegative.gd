extends ItemData

func _init() -> void:
    name = tr("Faded Negative");
    flavour_text = tr("I... can't remember...");
    description = tr("Damage dealt has a chance to reflect back onto you.");

    price = -100;
    weight = 10.0;

    sprite = load("res://Sprites/Items/FadedNegative.tres");
    function = load("res://Items/PainfulFunctions/FadedNegativeFunction.gd");

    unique_stacking = true;
    painful = true;
