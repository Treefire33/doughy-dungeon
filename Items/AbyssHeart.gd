extends ItemData

func _init() -> void:
    name = tr("Abyss Heart");
    flavour_text = tr("The heart of the abyss. A strange force overwhelmes you.");
    description = tr("Every room passed, -1 max health, +5 max stamina. Every item bought, +1 max health, -5 max stamina. Every enemy killed, +1 attack. Every time you rest, -1 attack.");

    price = 0;
    weight = 0.0;

    sprite = load("res://Sprites/Items/AbyssHeart.tres");
    function = load("res://Items/Functions/AbyssHeartFunction.gd");

    unique_stacking = false;
    painful = false;
