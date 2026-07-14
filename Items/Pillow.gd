extends ItemData

func _init() -> void:
    name = tr("Pillow");
    flavour_text = tr("Comfy!");
    description = tr("Reseting recovers more stamina.");

    price = 50;
    weight = 9.0;

    sprite = load("res://Sprites/Items/Pillow.tres");
    function = load("res://Items/Functions/PillowFunction.gd");

    unique_stacking = true;
    painful = false;
