extends Resource
class_name ItemData

@export_category("Item Data")
@export var name: String;
@export_multiline var flavour_text: String;
@export_multiline var description: String;
@export var price: int;
@export var sprite: Texture;
@export var weight: float;
@export var function: GDScript;
@export var unique_stacking: bool = false;
