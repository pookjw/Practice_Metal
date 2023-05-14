//
//  Lighting.metal
//  Project10
//
//  Created by Jinwoo Kim on 5/12/23.
//

#include <metal_stdlib>
using namespace metal;

#import "Lighting.h"

float3 phongLighting(
                     float3 normal,
                     float3 position,
                     constant Params &params,
                     constant Light *lights,
                     float3 baseColor
                     )
{
    float3 diffuseColor = 0;
    float3 ambientColor = 0;
    float3 specularColor = 0;
    
    for (uint i = 0; i < params.lightCount; i++) {
        Light light = lights[i];
        
        switch (light.type) {
            case Sun: {
                float3 lightDirection = normalize(-light.position);
                float diffuseIntensity = saturate(-dot(lightDirection, normal));
                diffuseColor += light.color * baseColor * diffuseIntensity;
                break;
            }
            case _Point: {
                break;
            }
            case Spot: {
                break;
            }
            case Ambient: {
                break;
            }
            case unused: {
                break;
            }
        }
    }
    
    return diffuseColor + specularColor + ambientColor;
}
