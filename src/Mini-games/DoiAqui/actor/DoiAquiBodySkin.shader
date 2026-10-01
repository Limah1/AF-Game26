shader_type canvas_item;

uniform vec4 target_skin : hint_color = vec4(1.0);
uniform vec4 target_shirt : hint_color = vec4(1.0);
uniform vec4 target_pants : hint_color = vec4(0.94, 0.72, 0.15, 1.0);

void fragment() {
	vec4 pixel = texture(TEXTURE, UV);
	float brightness = max(max(pixel.r, pixel.g), pixel.b);
	vec3 chroma = pixel.rgb / max(brightness, 0.001);
	if (pixel.a > 0.01) {
		if (chroma.g > 0.8 && chroma.r < 0.35 && chroma.b < 0.35) {
			pixel.rgb = target_skin.rgb * brightness;
		} else if (chroma.r > 0.9 && chroma.g > 0.55 && chroma.g < 0.9 && chroma.b < 0.35) {
			pixel.rgb = target_pants.rgb * brightness;
		} else if (UV.y < 0.73 && min(min(pixel.r, pixel.g), pixel.b) > 0.7) {
			pixel.rgb = target_shirt.rgb * brightness;
		}
	}
	COLOR = pixel;
}
