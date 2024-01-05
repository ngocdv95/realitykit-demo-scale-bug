//
//  TestShader.metal
//  DemoRealityBug
//
//  Created by Virtual Try On on 05/01/2024.
//

#include <metal_stdlib>
using namespace metal;
#include <RealityKit/RealityKit.h>

[[visible]]
void emptyGeometryModifier(realitykit::geometry_parameters params)
{
    params.geometry();
}
