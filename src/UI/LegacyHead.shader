shader_type canvas_item;

uniform vec4 source_skin : hint_color = vec4(0.0, 1.0, 0.0, 1.0);
uniform vec4 target_skin : hint_color = vec4(1.0, 1.0, 1.0, 1.0);
// Compare hue independently from brightness so antialiased green pixels next
// to the black outlines are replaced too.
uniform float tolerance : hint_range(0.0, 1.0) = 0.18;

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	float current_brightness = max(max(current_pixel.r, current_pixel.g), current_pixel.b);
	float source_brightness = max(max(source_skin.r, source_skin.g), source_skin.b);
	vec3 current_chroma = current_pixel.rgb / max(current_brightness, 0.001);
	vec3 source_chroma = source_skin.rgb / max(source_brightness, 0.001);
	if (current_pixel.a > 0.01 && current_brightness > 0.01 && length(current_chroma - source_chroma) < tolerance) {
		float shade = clamp(current_brightness / source_brightness, 0.0, 1.0);
		current_pixel.rgb = target_skin.rgb * shade;
	}
	COLOR = current_pixel;
}
