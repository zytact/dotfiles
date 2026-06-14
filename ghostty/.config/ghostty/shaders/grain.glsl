// Subtle background grain. Strongest on dark pixels; keeps bright text mostly intact.
float hash12(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 src = texture(iChannel0, uv);

    float luma = dot(src.rgb, vec3(0.299, 0.587, 0.114));
    float dark_mix = 0.55 * (1.0 - smoothstep(0.05, 0.32, luma));

    float base = hash12(fragCoord);
    float fine = hash12(fragCoord * 1.73 + 19.4);
    float grain = ((base - 0.5) * 0.010 + (fine - 0.5) * 0.005) * dark_mix;

    float speck = smoothstep(0.992, 1.0, hash12(floor(fragCoord * 0.5) + 73.1));
    grain += speck * 0.003 * dark_mix;

    fragColor = vec4(clamp(src.rgb + grain, 0.0, 1.0), src.a);
}
