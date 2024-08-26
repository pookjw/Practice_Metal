//
//  Lighting.h
//  Project10
//
//  Created by Jinwoo Kim on 5/12/23.
//

#ifndef Lighting_h
#define Lighting_h

#import "common.h"

float3 phongLighting(
                     float3 normal,
                     float3 position,
                     constant Params &params,
                     constant Light *lights,
                     float3 baseColor
                     );


#endif /* Lighting_h */
