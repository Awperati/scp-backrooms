shader_type canvas_item;

uniform float sanity : source_color = 1.0;
uniform float vignette_strength = 0.8;
uniform vec4 vignette_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float flicker_threshold = 0.3;
uniform float flicker_speed = 12.0;
uniform float flicker_intensity = 0.4;

void fragment() {
	vec4 color = texture(TEXTURE, UV);

	// Vignette: darken edges as sanity drops
	float dist = distance(UV, vec2(0.5)) * 1.414;
	float vig = smoothstep(0.3, 1.0, dist) * vignette_strength * (1.0 - sanity);
	color.rgb = mix(color.rgb, vignette_color.rgb, vig);

	// Flicker: only when sanity below threshold
	if (sanity < flicker_threshold) {
		float t = TIME * flicker_speed;
		float flicker = sin(t) * 0.5 + sin(t * 2.7) * 0.3 + sin(t * 5.3) * 0.2;
		float flick = max(0.0, flicker) * flicker_intensity * (1.0 - sanity / flicker_threshold);
		color.rgb -= vec3(flick);
	}

	COLOR = color;
}
