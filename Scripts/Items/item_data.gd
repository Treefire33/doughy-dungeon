extends Resource
class_name ItemData

@export_category("Item Data")
## Displayed name of the item.
@export var name: String;

## Fun description of item.
@export_multiline var flavour_text: String;

## Formal description of mechanics.
@export_multiline var description: String;

## Item's rarity bucket.
@export var rarity: Enum.ItemRarity;

## The price of the item.
@export var price: int;

## The path to the sprite of the item.
@export var sprite: StringName;

## How likely the item is to appear in shop (higher is more common).
@export var weight: float;

## The associated [ItemFunction] of this item.
@export var function: GDScript;

## Determines if the item has a unique function for stacking.
@export var unique_stacking: bool = false;

## Denotes if an item is painful or not.
@export var painful: bool = false;

## Denotes if an item stacks at all.
@export var stacks: bool = true;

## Which dungeon's item pools this item appears in.
@export var dungeon_pool: Array[Enum.Dungeon] = [ Enum.Dungeon.All ];

## Which dungeon's item pools this item WONT appear in.
@export var dungeon_exclude_pool: Array[Enum.Dungeon] = [];
