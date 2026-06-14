// Subtle grain for both light and dark themes.
// Biases toward mid/background tones and avoids pushing high-contrast text too hard.
float hash12(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.1031);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 uv = fragCoord / iResolution.xy;
    vec4 src = texture(iChannel0, uv);

    float luma = dot(src.rgb, vec3(0.299, 0.587, 0.114));
    float dark_mix = 1.0 - smoothstep(0.08, 0.45, luma);
    float light_mix = smoothstep(0.65, 0.97, luma);
    float amount = mix(0.018, 0.036, dark_mix) + light_mix * 0.016;

    float base = hash12(fragCoord);
    float fine = hash12(fragCoord * 1.73 + 19.4);
    float grain = ((base - 0.5) * amount) + ((fine - 0.5) * amount * 0.55);

    float speck = smoothstep(0.992, 1.0, hash12(floor(fragCoord * 0.5) + 73.1));
    grain += speck * (dark_mix * 0.014 + light_mix * 0.008);

    fragColor = vec4(clamp(src.rgb + grain, 0.0, 1.0), src.a);
}
