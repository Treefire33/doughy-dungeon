extends ItemData

func _init() -> void:
    name = tr("Ivory Key");
    flavour_text = tr("1-e-and-a, 2-e-and-a, 3-e-and-a...");
    description = tr("Every consecutive same-decision increases its respective stat by 1, only for that room however.");

    price = 240;
    weight = 0.4;

    sprite = load("res://Sprites/Items/IvoryKey.tres");
    function = load("res://Items/Functions/IvoryKeyFunction.gd");

    unique_stacking = true;
    painful = false;
