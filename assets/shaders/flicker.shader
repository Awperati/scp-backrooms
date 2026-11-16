shader_type canvas_item;
render_mode unshaded;

uniform float flicker_speed = 5.0;
uniform float flicker_intensity = 0.3;

void fragment() {
	float noise = fract(sin(dot(UV * flicker_speed, vec2(12.9898, 78.233))) * 43758.5453);
	float flicker = 1.0 - noise * flicker_intensity;
	COLOR = vec4(vec3(flicker), 1.0);
}
