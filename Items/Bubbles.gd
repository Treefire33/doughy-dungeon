extends ItemData

func _init() -> void:
    name = tr("Bubbles");
    flavour_text = tr("*POP* Wowie! *POP* So fun!!");
    description = tr("The Shield Spell now lasts infinitely longer, yet is extremely fragile.");

    price = 150;
    weight = 4.0;

    sprite = load("res://Sprites/Items/Bubbles.tres");
    function = load("res://Items/Functions/BubblesFunction.gd");

    unique_stacking = true;
    painful = false;
