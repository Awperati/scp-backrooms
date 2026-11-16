shader_type canvas_item;

uniform float time : 0.0;
uniform float flicker_intensity : 0.5;
uniform float sanity_level : 0.0;

void fragment() {
	// Basic sanity effect - flickering and color shifts
	float flicker = sin(time * 10.0) * flicker_intensity;
	vec3 color = texture(TEXTURE, UV).rgb;
	
	// Apply sanity-based color shifts
	color.r += sanity_level * 0.2;
	color.g -= sanity_level * 0.1;
	color.b += sanity_level * 0.1;
	
	COLOR = vec4(color + flicker, 1.0);
}