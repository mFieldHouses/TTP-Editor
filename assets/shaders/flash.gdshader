shader_type canvas_item;

uniform float period = 1.0;

uniform vec4 color_1 : source_color = vec4(1.0, 1.0, 1.0, 0.0);
uniform vec4 color_2 : source_color = vec4(1.0, 1.0, 1.0, 1.0);

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = mix(color_1, color_2, (sin(TIME * 2.0 * PI / (period)) + 1.0) * 0.5);
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
