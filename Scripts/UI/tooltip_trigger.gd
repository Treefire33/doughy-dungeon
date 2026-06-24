extends Node
class_name TooltipTrigger

static var global_tooltip: Tooltip = Tooltip.tooltip_template.instantiate() as Tooltip;
@export_multiline() 
var text: String = "";

func _mouse_entered() -> void:
    if (self.text == ""): return;
    global_tooltip.toggle(self.text);

func _mouse_exited() -> void:
    global_tooltip.visible = false;

func _ready() -> void:
    var node = get_node("..") as Control;
    if (node):
        node.mouse_entered.connect(_mouse_entered);
        node.mouse_exited.connect(_mouse_exited);
    
func _process(delta: float) -> void:
    if (!global_tooltip): global_tooltip = Tooltip.tooltip_template.instantiate() as Tooltip;
    if (global_tooltip.get_parent() == null): get_tree().current_scene.add_child(global_tooltip);
