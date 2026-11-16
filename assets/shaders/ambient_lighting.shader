shader_type spatial;
render_mode depth_test, cull_back;

// Ambient lighting shader for SCP Backrooms game
// Provides dynamic ambient lighting effects

uniform float ambient_intensity : 0.2;
uniform vec3 ambient_color : vec3(0.1, 0.1, 0.1);

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
	
	// Calculate ambient lighting
	vec3 ambient = ambient_color * ambient_intensity;
	
	// Add directional lighting
	vec3 light_dir = normalize(vec3(0.5, 1.0, 0.5));
	vec3 light = max(dot(normal, light_dir), 0.0);
	
	// Apply lighting to albedo
	vec3 result = albedo * (ambient + light);
	
	// Apply alpha
	COLOR = vec4(result, 1.0);
}