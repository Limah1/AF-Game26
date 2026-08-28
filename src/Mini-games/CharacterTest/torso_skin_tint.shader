shader_type canvas_item;

uniform vec4 skin_tone : hint_color = vec4(1.0);
uniform float white_threshold = 0.82;
uniform float white_softness = 0.14;
uniform float color_limit = 0.24;

void fragment() {
	vec4 source = texture(TEXTURE, UV);
	float minimum_channel = min(min(source.r, source.g), source.b);
	float maximum_channel = max(max(source.r, source.g), source.b);
	float color_range = maximum_channel - minimum_channel;

	// Swimwear PNGs contain white skin and colored garments in one texture.
	// Tint only bright, low-saturation pixels so the garment colors remain intact.
	float white_mask = smoothstep(white_threshold - white_softness, white_threshold, minimum_channel);
	float skin_mask = white_mask * (1.0 - smoothstep(color_limit * 0.5, color_limit, color_range));
	vec3 tinted_skin = source.rgb * skin_tone.rgb;

	COLOR = vec4(mix(source.rgb, tinted_skin, skin_mask), source.a);
}
