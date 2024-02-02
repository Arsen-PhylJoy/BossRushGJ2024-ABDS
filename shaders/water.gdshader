shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform sampler2D foam;
uniform vec4 foam_color : source_color = vec4(1.0);
uniform float vel_time = 1.0f;

void fragment() {
	
	//Texture 1
	vec2 offset = vec2(TIME, 0);
	vec2 repeatedUV = mod(UV * 25.0 + (offset * vel_time), 1.0);
	vec4 foamtex = texture(foam, repeatedUV);
	
	//Texture 2
	vec2 offset2 = vec2(TIME, 2.0);
	vec2 repeatedUV2 = mod(UV * 25.0 + (offset2 *  (-vel_time)), 1.0);
	vec4 foamtex2 = texture(foam, repeatedUV2);
	
	//Final color
	vec4 finalFoam = mix(foamtex,foamtex2, 0.8);
	
	COLOR = foam_color + finalFoam;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
