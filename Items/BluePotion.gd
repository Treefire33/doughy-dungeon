extends ItemData

func _init() -> void:
    name = tr("Blue Potion");
    flavour_text = tr("Inspiring!");
    description = tr("Increases Shield Spell duration by 1 turn.");

    price = 75;
    weight = 8.0;

    sprite = load("res://Sprites/Items/BluePotion.tres");
    function = load("res://Items/Functions/BluePotionFunction.gd");

    unique_stacking = false;
    painful = false;
