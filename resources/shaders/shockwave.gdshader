shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_linear_mipmap;

uniform vec2 center;
uniform float force;
uniform float size;
uniform float thickness;
uniform float color_offset;


void fragment() {
	float ratio = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 scaled_uv = (SCREEN_UV - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	vec2 scaled_center = (center - vec2(0.5, 0.0)) / vec2(ratio, 1.0) + vec2(0.5, 0.0);
	float mask_inner = smoothstep(size-0.2, size, length(scaled_uv - scaled_center));
	float mask_outer = 1.0 - smoothstep(size+thickness-0.2, size+thickness, length(scaled_uv - scaled_center));
	float mask = mask_inner * mask_outer;
	float color_offset_mask = color_offset*mask/10.0;
	float masked_dimmer = mask * 0.1;
	vec2 displacement = normalize(scaled_uv - scaled_center) * force * mask;
	COLOR = texture(screen_texture, SCREEN_UV - displacement);
	// Red is offset left and down
	COLOR.r = texture(screen_texture, vec2(SCREEN_UV.x - color_offset_mask, SCREEN_UV.y + color_offset_mask) - displacement).r - masked_dimmer;
	// Green is offset up
	COLOR.g = texture(screen_texture, vec2(SCREEN_UV.x, SCREEN_UV.y - color_offset_mask) - displacement).g - masked_dimmer;
	// Blue is offset right and down
	COLOR.b = texture(screen_texture, vec2(SCREEN_UV.x + color_offset_mask, SCREEN_UV.y + color_offset_mask) - displacement).b - masked_dimmer;
	// Uncomment
	//COLOR.rgb = vec3(mask);
	
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
