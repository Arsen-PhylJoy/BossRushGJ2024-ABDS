shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform sampler2D noise_tex;
uniform float opacity = 0.4;
uniform float speed_fog = 0.1;

void fragment() {
	
	vec2 offset = vec2(TIME, 0);
	vec2 repeatedUV = mod(UV + (offset * speed_fog), 1.0);
	vec4 noise = texture(noise_tex, repeatedUV);
	
	vec2 offset2 = vec2(TIME, 0);
	vec2 repeatedUV2 = mod(UV + (offset2 * -speed_fog), 1.0);
	vec4 noise2 = texture(noise_tex, repeatedUV2);
	
	vec4 final_noise = mix(noise, noise2, 0.5);
	
	COLOR = vec4(1.0, 1.0, 1.0, final_noise.r) * vec4(1.0f, 1.0f, 1.0f, opacity);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
