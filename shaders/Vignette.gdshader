shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

uniform float smooth_circle = 0.109f;
uniform float radio = 0.3f;

void fragment() {
	float center = 0.5f;
	float c = length(UV - center);
	float circle = smoothstep(c - smooth_circle, c + smooth_circle, radio);
	COLOR = (1.0 - circle) * vec4(0.0, 0.0, 0.0, 1.0);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
