extends ItemData

func _init() -> void:
    name = tr("Guild Banner");
    flavour_text = tr("Show your pride of your priorities!");
    description = tr("(1, 2, 3) -> (3, 2, 1). Show your priorities.");

    price = 350;
    weight = 1.2;

    sprite = load("res://Sprites/Items/GuildBanner.tres");
    function = load("res://Items/Functions/GuildBannerFunction.gd");

    unique_stacking = true;
    painful = false;
