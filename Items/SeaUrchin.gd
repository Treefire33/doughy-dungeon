extends ItemData

func _init() -> void:
    name = tr("Urchin");
    flavour_text = tr("I won't make the same mistake twic- OUCH!");
    description = tr("I'm not actually sure what this does.");

    price = 1;
    weight = 7.0;

    sprite = load("res://Sprites/Items/SeaUrchin.tres");
    function = load("res://Items/Functions/SeaUrchinFunction.gd");

    unique_stacking = true;
    painful = false;
