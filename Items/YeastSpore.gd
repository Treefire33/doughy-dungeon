extends ItemData

func _init() -> void:
    name = tr("Yeast Spore");
    flavour_text = tr("Yeast Crawler egg... ugh");
    description = tr("Resting now decreases defense duration.");

    price = -50;
    weight = 10.0;

    sprite = load("res://Sprites/Items/YeastSpore.tres");
    function = load("res://Items/PainfulFunctions/YeastSporeFunction.gd");

    unique_stacking = true;
    painful = true;
