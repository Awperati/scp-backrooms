shader_type canvas_item;

uniform float flicker_intensity : 0.0..1.0 = 0.5;
uniform float flicker_speed : 0.0..10.0 = 5.0;

void fragment() {
	float time = TIME * flicker_speed;
	float flicker = sin(time) * flicker_intensity;
	COLOR.rgb += vec3(flicker);
}