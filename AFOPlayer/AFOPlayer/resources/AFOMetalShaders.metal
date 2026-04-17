#include <metal_stdlib>
using namespace metal;

struct AFOVertexIn {
    float2 position    [[attribute(0)]];
    float2 textureCoordinate [[attribute(1)]];
};

struct AFOVertexOut {
    float4 position    [[position]];
    float2 textureCoordinate;
};

vertex AFOVertexOut vertexShader(AFOVertexIn in [[stage_in]]) {
    AFOVertexOut out;
    out.position = float4(in.position, 0.0, 1.0);
    out.textureCoordinate = in.textureCoordinate;
    return out;
}

fragment float4 fragmentShader(AFOVertexOut in [[stage_in]],
                                texture2d<float, access::sample> yTexture [[texture(0)]],
                                texture2d<float, access::sample> uvTexture [[texture(1)]]) {
    constexpr sampler s(address::clamp_to_edge, filter::linear);
    float y = yTexture.sample(s, in.textureCoordinate).r;
    float2 uv = uvTexture.sample(s, in.textureCoordinate).rg;
    float r = y + 1.402 * (uv.y - 0.5);
    float g = y - 0.344 * (uv.x - 0.5) - 0.714 * (uv.y - 0.5);
    float b = y + 1.772 * (uv.x - 0.5);
    return float4(r, g, b, 1.0);
}
