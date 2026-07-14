extends ItemData

func _init() -> void:
    name = tr("Gold Amulet");
    flavour_text = tr("Lustrous amulet made of pure gold.");
    description = tr("Enemies drop more coins.");

    price = 175;
    weight = 3.0;

    sprite = load("res://Sprites/Items/GoldAmulet.tres");
    function = load("res://Items/Functions/GoldAmuletFunction.gd");

    unique_stacking = false;
    painful = false;
