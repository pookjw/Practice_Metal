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
    float materialShininess = 32.f;
    float3 materialSpecularColor = float3(1.f, 1.f, 1.f);
    
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
                
                if (diffuseIntensity > 0.f) {
                    float3 reflection = reflect(lightDirection, normal);
                    float3 viewDirection = normalize(params.cameraPosition);
                    float specularIntensity = pow(saturate(dot(reflection, viewDirection)), materialShininess);
                    
                    specularColor += light.specularColor * materialSpecularColor * specularIntensity;
                }
                
                break;
            }
            case _Point: {
                break;
            }
            case Spot: {
                break;
            }
            case Ambient: {
                ambientColor += light.color;
                break;
            }
            case unused: {
                break;
            }
        }
    }
    
    return diffuseColor + specularColor + ambientColor;
}
