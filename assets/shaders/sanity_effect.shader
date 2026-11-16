shader_type canvas_item;

void fragment() {
	// Basic sanity effect - flickering and color shifts
	vec3 color = texture(TEXTURE, UV).rgb;
	float flicker = sin(TIME * 10.0) * FLICKER_INTENSITY;
	
	// Apply sanity-based color shifts
	color.r += SANITY_LEVEL * 0.2;
	color.g -= SANITY_LEVEL * 0.1;
	color.b += SANITY_LEVEL * 0.1;
	
	COLOR = vec4(color + flicker, 1.0);
}