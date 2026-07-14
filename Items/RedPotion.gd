extends ItemData

func _init() -> void:
    name = tr("Red Potion");
    flavour_text = tr("Healthy!");
    description = tr("Increases max health by 2.");

    price = 50;
    weight = 7.0;

    sprite = load("res://Sprites/Items/RedPotion.tres");
    function = load("res://Items/Functions/RedPotionFunction.gd");

    unique_stacking = false;
    painful = false;
