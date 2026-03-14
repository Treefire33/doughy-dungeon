extends Resource
class_name ItemData

@export_category("Item Data")
## Displayed name of the item.
@export var name: String;

## Fun description of item.
@export_multiline var flavour_text: String;

## Formal description of mechanics.
@export_multiline var description: String;

## The price of the item.
@export var price: int;

## The sprite of the item.
@export var sprite: Texture;

## How likely the item is to appear in shop (higher is more common).
@export var weight: float;

## The associated [ItemFunction] of this item.
@export var function: GDScript;

## Determines if the item has a unique function for stacking.
@export var unique_stacking: bool = false;
