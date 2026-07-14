extends ItemData

func _init() -> void:
    name = tr("Urchin");
    flavour_text = tr("I won't make the same mistake thri- ow...");
    description = tr("I'm not actually sure what this does, but it can't be good.");

    price = -25;
    weight = 1.0;

    sprite = load("res://Sprites/Items/SeaUrchin.tres");
    function = load("res://Items/PainfulFunctions/SeaUrchinPainfulFunction.gd");

    unique_stacking = true;
    painful = true;
