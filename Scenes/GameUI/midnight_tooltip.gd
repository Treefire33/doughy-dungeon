extends ColorRect
class_name Tooltip

static var tooltip_template: PackedScene = preload("res://Scenes/GameUI/tooltip.tscn");

var text: String = "":
    get: return text;
    set(value):
        if (! self.is_node_ready()): return;
        text = value;

var default_line_size: int = 12;
var padding: Vector2 = Vector2(32, 32);
var margin: Vector2i = Vector2i(16, 16);
var max_size: Vector2i = Vector2i(250, 200) + self.margin;
var locked: bool = false;

@onready var text_container: VBoxContainer = $Margin/TextContainer;
@onready var margin_container: Control = $Margin;

func _create_text_label(label_text: String, size: int = default_line_size) -> RichTextLabel:
    var new_label = RichTextLabel.new();
    new_label.fit_content = true;
    new_label.custom_minimum_size = Vector2(max_size.x, 0);
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
    
    for line in text.strip_edges().split('\n'):
        var processed_text: Array = _process_text(line);
        var label: RichTextLabel = _create_text_label(processed_text[0], processed_text[1]);
        # label.draw.connect(_on_label_draw.bind(label), ConnectFlags.CONNECT_DEFERRED | ConnectFlags.CONNECT_ONE_SHOT);
        text_container.add_child(label);

func _regenerate_tooltip() -> void:
    self.size = Vector2(max_size.x, 0);
    _generate_tooltip_text();

# func _on_label_draw(label: RichTextLabel):
#     self.size = Vector2(max_size.x, min(max_size.y, self.size.y + label.size.y));

func _on_container_draw():
    print(text_container.size.y);
    self.size = Vector2(max_size.x, min(max_size.y, text_container.size.y + margin.y));

func toggle(new_text: String):
    self.text = new_text;
    _regenerate_tooltip();
    self.visible = true;

func _ready() -> void:
    self.visible = false;
    self.z_index = 999;
    self.text_container.draw.connect(_on_container_draw, ConnectFlags.CONNECT_DEFERRED);
    _regenerate_tooltip();

func _process(delta: float) -> void:
    if (!self.visible): return;
    var position = get_viewport().get_mouse_position().min(get_viewport().get_visible_rect().size - self.size - self.padding);
    if (self.locked):
        position = get_viewport().get_mouse_position().min(self.trigger.get_viewport_rect().size);
    
    self.position = round(position + padding);
