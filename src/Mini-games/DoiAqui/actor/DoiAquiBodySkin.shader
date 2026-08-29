shader_type canvas_item;

// The visible DoiAqui body is white so it can receive any selected skin tone.
// A matching brown body texture is used only as a mask, which keeps the white
// hospital shirt and the colored wounds untouched.
uniform sampler2D skin_mask;
uniform vec4 target_skin : hint_color = vec4(1.0, 1.0, 1.0, 1.0);

void fragment() {
	vec4 current_pixel = texture(TEXTURE, UV);
	vec4 mask_pixel = texture(skin_mask, UV);

	float red = max(mask_pixel.r, 0.0001);
	float green_ratio = mask_pixel.g / red;
	float blue_ratio = mask_pixel.b / red;
	bool is_skin = mask_pixel.a > 0.01
		&& mask_pixel.r >= 0.031
		&& mask_pixel.r <= 0.53
		&& mask_pixel.r > mask_pixel.g
		&& mask_pixel.g > mask_pixel.b
		&& abs(green_ratio - 0.7244) <= 0.07
		&& abs(blue_ratio - 0.4882) <= 0.08;

	if (is_skin) {
		// The grayscale edge in the white sprite preserves antialiasing.
		current_pixel.rgb = target_skin.rgb * current_pixel.r;
	}

	COLOR = current_pixel;
}
