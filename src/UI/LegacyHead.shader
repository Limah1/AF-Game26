shader_type canvas_item;

uniform vec4 source_skin : hint_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform vec4 target_skin : hint_color = vec4(1.0, 1.0, 1.0, 1.0);
// Keep the skin replacement narrow so nearby hair/clothing colors are not
// recolored along with the face.
uniform float tolerance : hint_range(0.0, 1.0) = 0.18;

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	if (current_pixel.a > 0.01 && length(current_pixel.rgb - source_skin.rgb) < tolerance) {
		current_pixel.rgb = target_skin.rgb;
	}
	COLOR = current_pixel;
}
