extends ItemData

func _init() -> void:
    name = tr("Durability Scroll");
    flavour_text = tr("A scroll containing arcane instructions.");
    description = tr("Increases Shield Spell durability by 1 HP.");

    price = 125;
    weight = 5.0;

    sprite = load("res://Sprites/Items/DurabilityScroll.tres");
    function = load("res://Items/Functions/DurabilityScrollFunction.gd");

    unique_stacking = false;
    painful = false;
