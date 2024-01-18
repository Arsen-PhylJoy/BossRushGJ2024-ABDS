shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform sampler2D noise_sampler;
uniform float mix_textures;
uniform float mix_speed : hint_range(0.1, 2.0) = 1.0;

void fragment() {
	vec4 noise_texture = texture(noise_sampler, UV);
	vec4 base_color = texture(TEXTURE, UV);
	
	float time = TIME;
	float mix_factor = (sin(time * mix_speed) + 1.0) * 0.5;
	vec4 get_color = mix(vec4((noise_texture.rgb * base_color.rgb), noise_texture.r), base_color, noise_texture.r);
	vec4 get_color2 = mix(get_color, base_color, mix_factor);
	COLOR = get_color2;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
