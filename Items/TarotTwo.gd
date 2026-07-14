extends ItemData

func _init() -> void:
    name = tr("The Spellcaster - II")
    flavour_text = tr("SPELL PLACEHOLDER")
    description = tr("SPELL PLACEHOLDER")

    price = 0
    weight = 0.0

    sprite = load("res://Sprites/Items/Tarot/TarotTwo_Spell.tres")
    function = null

    unique_stacking = true
    painful = true
