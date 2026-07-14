extends ItemData

func _init() -> void:
    name = tr("Coffee");
    flavour_text = tr("A strong, aromatic smell eminates from the cup. It gives you a headache.");
    description = tr("Stamina won't drain, period. However, sometimes you'll randomly take a single point of damage (remember that headache?).");

    price = 400;
    weight = 0.1;

    sprite = load("res://Sprites/Items/Coffee.tres");
    function = load("res://Items/Functions/CoffeeFunction.gd");

    unique_stacking = true;
    painful = false;
