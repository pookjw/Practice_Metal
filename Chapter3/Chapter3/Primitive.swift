//
//  Primitive.swift
//  Chapter3
//
//  Created by Jinwoo Kim on 7/17/22.
//

import Foundation
import MetalKit

class Primitive {
    static func makeCube(device: MTLDevice, size: Float) -> MDLMesh {
        let allocator: MTKMeshBufferAllocator = .init(device: device)
//        let mesh: MDLMesh = .init(boxWithExtent: [size, size, size],
//                                  segments: [1, 1, 1],
//                                  inwardNormals: false,
//                                  geometryType: .triangles,
//                                  allocator: allocator)
        
        let trainUrl: URL = Bundle.main.url(forResource: "train", withExtension: "obj")!
        let vertexDescriptor: MTLVertexDescriptor = .init()
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<SIMD3<Float>>.stride
        
        let vertexAttributeDescriptor: MTLVertexAttributeDescriptor = vertexDescriptor.attributes[0]!
        vertexAttributeDescriptor.format = .float3
        vertexAttributeDescriptor.offset = .zero
        vertexAttributeDescriptor.bufferIndex = .zero
        
        let meshDescriptor: MDLVertexDescriptor = try! MTKModelIOVertexDescriptorFromMetalWithError(vertexDescriptor)
        (meshDescriptor.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        
        let asset: MDLAsset = .init(url: trainUrl, vertexDescriptor: meshDescriptor, bufferAllocator: allocator)
        let mesh: MDLMesh = asset.childObjects(of: MDLMesh.self).first as! MDLMesh
        
        return mesh
    }
}
