extends ItemData

func _init() -> void:
    name = tr("Fragment of the Abyss");
    flavour_text = tr("A piece of the abyss, don't stare for too long.");
    description = tr("???");

    price = 450;
    weight = 0.9;

    sprite = load("res://Sprites/Items/AbyssFragment.tres");
    function = load("res://Items/Functions/AbyssFragmentFunction.gd");

    unique_stacking = false;
    painful = false;
