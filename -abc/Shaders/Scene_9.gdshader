shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float progress : hint_range(0.0, 1.0) = 0.0;

uniform vec4 deep_blue : source_color = vec4(0.05, 0.15, 0.40, 1.0);
uniform vec4 medium_blue : source_color = vec4(0.15, 0.35, 0.75, 1.0);
uniform vec4 foam_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);

varying float v_wave;
varying vec2 v_uv;

void vertex()
{
    v_uv = UV;

    float wave =
        sin(UV.x * 10.0 + TIME)
        * 0.2;

    VERTEX.y += wave;

    v_wave = wave;
}

void fragment()
{
    vec2 uv = v_uv;

    float stripes =
        sin(
            uv.y * 40.0 +
            uv.x * 8.0 +
            TIME * 0.5
        );

    vec3 color =
        mix(
            deep_blue.rgb,
            medium_blue.rgb,
            smoothstep(-0.2, 0.2, stripes)
        );

    float foam =
        smoothstep(
            0.12,
            0.18,
            v_wave
        );

    color =
        mix(
            color,
            foam_color.rgb,
            foam
        );

    ALBEDO = color;

    ALPHA = 1.0 - progress;
}