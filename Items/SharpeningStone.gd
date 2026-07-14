extends ItemData

func _init() -> void:
    name = tr("Sharpening Stone");
    flavour_text = tr("How do you sharpen a wooden sword?");
    description = tr("On attack, 25% chance to deal damage again.");

    price = 50;
    weight = 10.0;

    sprite = load("res://Sprites/Items/SharpeningStone.tres");
    function = load("res://Items/Functions/SharpeningStoneFunction.gd");

    unique_stacking = false;
    painful = false;
