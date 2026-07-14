extends ItemData

func _init() -> void:
    name = tr("Oven Mitt");
    flavour_text = tr("Hot-hot-hot- HOT!!");
    description = tr("Each room completed adds +1 to difficulty and +0.1x to multiplier. Resets when staying clear.");

    price = 250;
    weight = 1.0;

    sprite = load("res://Sprites/Items/OvenMitt.tres");
    function = load("res://Items/Functions/OvenMittFunction.gd");

    unique_stacking = false;
    painful = false;
