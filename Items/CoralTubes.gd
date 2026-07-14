extends ItemData

func _init() -> void:
    name = tr("Organ Coral");
    flavour_text = tr("A sweet melody plays from its tubes");
    description = tr("Resting heals (1 * stack) HP.");

    price = 175;
    weight = 5.5;

    sprite = load("res://Sprites/Items/CoralTubes.tres");
    function = load("res://Items/Functions/CoralTubesFunction.gd");

    unique_stacking = true;
    painful = false;
