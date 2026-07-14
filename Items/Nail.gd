extends ItemData

func _init() -> void:
    name = tr("Pure Nail");
    flavour_text = tr("The work of a skilled craftsman. The perfect weapon.");
    description = tr("Caps attack at 5, but allows you to peirce through shield spells.");

    price = 200;
    weight = 0.5;

    sprite = load("res://Sprites/Items/HKNail.tres");
    function = load("res://Items/Functions/NailFunction.gd");

    unique_stacking = true;
    painful = false;
