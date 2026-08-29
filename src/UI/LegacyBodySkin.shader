shader_type canvas_item;

// The Hidratona body sprites use this baked skin color. Replace only the
// skin pixels so the hands/legs stay in sync with the modular head overlay.
uniform vec4 source_skin : hint_color = vec4(0.807843, 0.733333, 0.615686, 1.0);
uniform vec4 target_skin : hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float tolerance : hint_range(0.0, 1.0) = 0.08;

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	if (current_pixel.a > 0.01 && length(current_pixel.rgb - source_skin.rgb) < tolerance) {
		current_pixel.rgb = target_skin.rgb;
	}
	COLOR = current_pixel;
}
