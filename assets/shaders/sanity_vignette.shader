shader_type canvas_item;

uniform float vignette_intensity = 0.5;
uniform float chromatic_aberration = 0.0;
uniform float distortion_amount = 0.0;

void fragment() {
	vec2 uv = UV;
	
	if (chromatic_aberration > 0.0) {
		vec2 center = vec2(0.5);
		vec2 dir = normalize(uv - center) * chromatic_aberration;
		float r = TEXTURE(texture, uv + dir).r;
		float g = TEXTURE(texture, uv).g;
		float b = TEXTURE(texture, uv - dir).b;
		COLOR = vec4(r, g, b, 1.0);
	} else {
		COLOR = TEXTURE(texture, uv);
	}
	
	float dist = distance(uv, vec2(0.5));
	float vig = 1.0 - smoothstep(0.3, 1.0, dist) * vignette_intensity;
	COLOR.rgb *= vig;
	
	if (distortion_amount > 0.0) {
		COLOR.rg += sin(COLOR.r * 10.0 + TIME) * distortion_amount * 0.1;
	}
}
