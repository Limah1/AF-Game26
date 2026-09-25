shader_type canvas_item;

uniform vec4 target_skin : hint_color = vec4(1.0);

void fragment() {
	vec4 pixel = texture(TEXTURE, UV);
	float green_excess = pixel.g - max(pixel.r, pixel.b);
	float mask = smoothstep(0.025, 0.10, green_excess);
	float shade = clamp(pixel.g / (245.0 / 255.0), 0.0, 1.0);
	pixel.rgb = mix(pixel.rgb, target_skin.rgb * shade, mask);
	COLOR = pixel;
}
