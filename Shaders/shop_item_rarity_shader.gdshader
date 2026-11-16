shader_type canvas_item;
uniform vec4 outline_colour: source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float outline_size = 1.0;

void fragment() {
    vec4 base = texture(TEXTURE, UV);
    if (base.a > 0.0) {
        COLOR = base;
    } else {
        vec2 ps = TEXTURE_PIXEL_SIZE;
        bool valid_side = false;
        for (float x = -outline_size; x <= outline_size; x += 1.0) {
            for (float y = -outline_size; y <= outline_size; y += 1.0) {
                if (texture(TEXTURE, UV + vec2(x * ps.x, y * ps.y)).a > 0.0) {
                    valid_side = true;
                    break;
                }
            }
        }
        
        if (valid_side) {
            COLOR = outline_colour;
        }
    }
}
