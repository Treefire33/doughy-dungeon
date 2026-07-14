extends ItemData

func _init() -> void:
    name = tr("Loose Fang");
    flavour_text = tr("A tooth from an unknown creature, it feels oddly familiar.");
    description = tr("On attack, 10% chance to siphon health.");

    price = 135;
    weight = 5.0;

    sprite = load("res://Sprites/Items/LooseFang.tres");
    function = load("res://Items/Functions/LooseFangFunction.gd");

    unique_stacking = false;
    painful = false;
