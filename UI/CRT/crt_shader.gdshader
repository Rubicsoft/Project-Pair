shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;

uniform sampler2D scanline_texture : hint_default_black, repeat_enable, filter_linear;
uniform float height = 180.0f;
uniform float scan_line_amount : hint_range(0.0, 1.0) = 0.5f;
uniform float scroll_speed : hint_range(0.0, 5.0, 0.1) = 1.0f;
uniform float warp_amount : hint_range(0.0, 1.0) = 0.05f;
uniform float chroma_strength : hint_range(0.0, 1.0, 0.01) = 1.0f;
uniform float brightness_boost : hint_range(1.0, 2.0) = 1.2f;
uniform float real_time = 0.0f;


void fragment() {
	vec2 uv = SCREEN_UV;
	vec3 color;

	// Optimized screen curvature distortion
	vec2 delta = uv - 0.5;
	float dist = delta.x * delta.x + delta.y * delta.y;
	uv += delta * dist * warp_amount;

	// Fast Scanlines
	vec2 scanline_uv = vec2(uv.x, height * (uv.y - (real_time * scroll_speed * 0.05)));
	float scanline = texture(scanline_texture, scanline_uv).r * scan_line_amount * 0.5;

	// Chromatic abberation
	vec2 center_dist = uv - 0.5;
	color.r = texture(screen_texture, uv + center_dist * chroma_strength / 100.0).r;
	color.g = texture(screen_texture, uv).g;
	color.b = texture(screen_texture, uv - center_dist * chroma_strength / 100.0).b;


	color *= (1.0 - scanline) * brightness_boost;

	COLOR = vec4(color, 1.0);
}