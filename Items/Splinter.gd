extends ItemData

func _init() -> void:
    name = tr("Splinter");
    flavour_text = tr("ow");
    description = tr("Every enemy attack now does (1 * stack) more damage.");

    price = -25;
    weight = 10.0;

    sprite = load("res://Sprites/Items/Splinter.tres");
    function = load("res://Items/PainfulFunctions/SplinterFunction.gd");

    unique_stacking = true;
    painful = true;
