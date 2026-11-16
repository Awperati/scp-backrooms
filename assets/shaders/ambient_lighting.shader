shader_type spatial;
render_mode depth_test, cull_back;

uniform float ambient_intensity : 0.2;
uniform vec3 ambient_color : vec3(0.1, 0.1, 0.1);

void fragment() {
	ALBEDO = vec3(0.0);
	
	// Ambient lighting
	vec3 ambient = ambient_color * ambient_intensity;
	
	// Apply ambient to base color
	ALBEDO = ambient;
	
	// Add a subtle glow effect for the backrooms
	vec3 glow = vec3(0.05, 0.05, 0.05);
	ALBEDO += glow;
}