shader_type canvas_item;

uniform vec4 skin_color : hint_color = vec4(0.92, 0.72, 0.58, 1.0);

void fragment() {
	vec4 pixel = texture(TEXTURE, UV);
	float shade = dot(pixel.rgb, vec3(0.299, 0.587, 0.114));
	COLOR = vec4(skin_color.rgb * clamp(shade / 0.86, 0.30, 1.18), pixel.a);
}
