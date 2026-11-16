shader_type spatial;
render_mode depth_test, cull_back;

// Ambient lighting shader for SCP Backrooms game
// Provides dynamic ambient lighting effects
//
// Parameters:
// - ambient_intensity: Controls overall ambient light strength (0.0 to 1.0)
// - ambient_color: Base color for ambient lighting
// - light_direction: Direction of the main light source

uniform float ambient_intensity : 0.2;
uniform vec3 ambient_color : vec3(0.1, 0.1, 0.1);
uniform vec3 light_direction : vec3(0.5, 1.0, 0.5);

// Vertex shader inputs
varying vec3 v_normal;

void vertex() {
	// Store normal for fragment shader
	v_normal = NORMAL;
}

void fragment() {
	// Get base albedo
	vec3 albedo = ALBEDO;
	
	// Normalize normal
	vec3 normal = normalize(v_normal);
	
	// Handle edge case where normal might be zero vector
	if (length(normal) < 1e-6) {
		normal = vec3(0.0, 1.0, 0.0);
	}
	
	// Calculate ambient lighting
	vec3 ambient = ambient_color * ambient_intensity;
	
	// Add directional lighting
	vec3 light = max(dot(normal, normalize(light_direction)), 0.0);
	
	// Apply lighting to albedo
	vec3 result = albedo * (ambient + light);
	
	// Apply alpha
	COLOR = vec4(result, 1.0);
}