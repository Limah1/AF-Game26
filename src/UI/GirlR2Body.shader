shader_type canvas_item;

uniform vec4 nova_cor_pele : hint_color;
uniform vec4 nova_cor_camisa : hint_color;
uniform vec4 nova_cor_calca : hint_color;

void fragment() {
	vec4 pixel = texture(TEXTURE, UV);
	if (pixel.a > 0.01) {
		if (length(pixel.rgb - vec3(0.47, 0.36, 0.25)) < 0.18) {
			pixel = vec4(nova_cor_pele.rgb, pixel.a);
		} else if (pixel.r > pixel.g * 2.0 && pixel.r > pixel.b * 2.0) {
			pixel = pixel.r < 0.85 ? vec4(0.0, 0.0, 0.0, pixel.a) : vec4(nova_cor_camisa.rgb, pixel.a);
		} else if (length(pixel.rgb - vec3(0.13, 0.14, 0.14)) < 0.18) {
			pixel = vec4(nova_cor_calca.rgb, pixel.a);
		}
	}
	COLOR = pixel;
}
