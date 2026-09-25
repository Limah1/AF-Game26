shader_type canvas_item;

uniform vec4 petal_color : hint_color = vec4(1.0);

void fragment() {
	vec4 source = texture(TEXTURE, UV);
	float lowest = min(source.r, min(source.g, source.b));
	float highest = max(source.r, max(source.g, source.b));
	float petal = smoothstep(0.55, 0.8, lowest) * (1.0 - smoothstep(0.1, 0.3, highest - lowest));
	COLOR = vec4(mix(source.rgb, source.rgb * petal_color.rgb, petal), source.a);
}
