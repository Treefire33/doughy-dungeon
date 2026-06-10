extends ColorRect
class_name Tooltip

static var tooltip_template: PackedScene = preload("res://Scenes/GameUI/tooltip.tscn");

var queued_recalculation: bool = false;
var text: String = "":
    get: return text;
    set(value):
        if (! self.is_node_ready()): return ;
        text = value;
        queued_recalculation = true;

var default_line_size: int = 12;
var padding: Vector2 = Vector2(32, 32);
var max_size: Vector2i = Vector2i(250, 200);
var locked: bool = false;

@onready var text_container: VBoxContainer = $Margin/TextContainer;

func _create_text_label(label_text: String, size: int = default_line_size) -> RichTextLabel:
    var new_label = RichTextLabel.new();
    # new_label.size_flags_vertical = Control.SIZE_FILL;
    #new_label.custom_minimum_size = Vector2(0, size);
    new_label.fit_content = true;
    new_label.add_theme_font_size_override("normal_font_size", size);
    new_label.text = label_text;
    return new_label;

func _process_text(text: String) -> Array:
    var i: int = 0;
    var final_text: String = "";
    var detected_size: int = default_line_size;
    while (i < text.length()):
        var character: String = text[i];
        if (character == '['):
            if (i >= text.length() || text[i + 1] != "s"):
                final_text += text[i];
                i += 1;
                continue ;
            i += 3; # should skip over [s=
            var size_text: String = "";
            while (text[i].is_valid_int()):
                size_text += text[i];
                i += 1;
            detected_size = int(size_text);
            i += 1; # skips over ]
            continue ;
        
        final_text += text[i];
        i += 1;
    
    return [final_text, detected_size];

func _generate_tooltip_text() -> void:
    for child in text_container.get_children():
        child.queue_free();
    
    for line in text.split('\n'):
        var processed_text: Array = _process_text(line);
        var label: RichTextLabel = _create_text_label(processed_text[0], processed_text[1]);
        text_container.add_child(label);

func _regenerate_tooltip() -> void:
    _generate_tooltip_text();

func _ready() -> void:
    self.visible = false;
    _regenerate_tooltip();
    
func _process(delta: float) -> void:
    if (!self.visible): return;
    if (queued_recalculation):
        self.visible = false;
        _regenerate_tooltip();
        self.queued_recalculation = false;
        self.visible = true;
    self.z_index = 999;
    var height: int = default_line_size;
    for label: RichTextLabel in text_container.get_children():
        height += default_line_size;
    self.size = Vector2(max_size.x, min(max_size.y, height));
    var position = get_viewport().get_mouse_position().min(get_viewport().get_visible_rect().size - self.size - self.padding);
    if (self.locked):
        position = get_viewport().get_mouse_position().min(self.trigger.get_viewport_rect().size);
    
    self.position = round(position + padding);
