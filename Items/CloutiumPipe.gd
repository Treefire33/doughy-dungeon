extends ItemData

func _init() -> void:
    name = tr("Cloutium Pipe");
    flavour_text = tr("Starting to feel like a real Hydroneer!");
    description = tr("Damage leaks over to nearby enemies.");

    price = 199;
    weight = 3.5;

    sprite = load("res://Sprites/Items/CloutiumPipe.tres");
    function = load("res://Items/Functions/CloutiumPipeFunction.gd");

    unique_stacking = true;
    painful = false;
