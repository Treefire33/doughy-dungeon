extends ItemData

func _init() -> void:
    name = tr("The Folly - I")
    flavour_text = tr("FOLLY PLACEHOLDER")
    description = tr("FOLLY PLACEHOLDER")

    price = 0
    weight = 0.0

    sprite = load("res://Sprites/Items/Tarot/TarotOne_Folly.tres")
    function = null

    unique_stacking = true
    painful = true
