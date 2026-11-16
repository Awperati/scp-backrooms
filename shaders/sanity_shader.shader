shader_type canvas_item;

// Shader for sanity effect in SCP Backrooms
// Creates flickering and distortion effects when sanity is low

uniform float time : float = 0.0;
uniform float sanity_level : float = 1.0;
uniform float flicker_intensity : float = 0.0;
uniform vec2 screen_size : vec2 = vec2(1280.0, 720.0);

void fragment() {
	// Base color
	vec3 color = texture(TEXTURE, UV).rgb;
	
	// Apply sanity-based distortion
	float distortion = 1.0 - sanity_level;
	
	// Add flickering effect
	float flicker = sin(time * 10.0) * flicker_intensity;
	
	// Create a subtle distortion effect
	vec2 distorted_uv = UV + vec2(
		sin(UV.x * 10.0 + time) * distortion * 0.01,
		cos(UV.y * 10.0 + time) * distortion * 0.01
	);
	
	// Apply flicker and distortion
	color = mix(color, vec3(0.0, 0.0, 0.0), flicker * 0.3);
	color = mix(color, vec3(0.1, 0.0, 0.0), distortion * 0.2);
	
	COLOR = vec4(color, texture(TEXTURE, UV).a);
}