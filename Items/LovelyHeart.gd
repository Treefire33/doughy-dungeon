extends ItemData

func _init() -> void:
    name = tr("Lovely Heart");
    flavour_text = tr("Wielding my love!");
    description = tr("Base attack stat is set to the number of heart items currently purchased.");

    price = 250;
    weight = 1.073;

    sprite = load("res://Sprites/Items/LovelyHeart.tres");
    function = load("res://Items/Functions/LovelyHeartFunction.gd");

    unique_stacking = true;
    painful = false;
