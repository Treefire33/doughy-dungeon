extends ItemData

func _init() -> void:
    name = tr("Whisk");
    flavour_text = tr("Shaking (stirring) things up!");
    description = tr("On attack, damage is randomized between base attack and 50% of max health.");

    price = 250;
    weight = 1.0;

    sprite = load("res://Sprites/Items/Whisk.tres");
    function = load("res://Items/Functions/WhiskFunction.gd");

    unique_stacking = false;
    painful = false;
