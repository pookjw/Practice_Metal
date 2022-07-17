//
//  Renderer.swift
//  Chapter3
//
//  Created by Jinwoo Kim on 7/17/22.
//

import Foundation
import MetalKit

class Renderer: NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    var mesh: MTKMesh!
    var vertexBuffer: MTLBuffer!
    var pipelineState: MTLRenderPipelineState!
    var timer: Float = .zero
    
    var uniforms: Uniforms = .init()
    
    init(mtkView: MTKView) {
        guard let device: MTLDevice = MTLCreateSystemDefaultDevice(),
              let commandQueue: MTLCommandQueue = device.makeCommandQueue() else {
            fatalError("GPU not available")
        }
        
        Self.device = device
        Self.commandQueue = commandQueue
        mtkView.device = device
        
        let library: MTLLibrary = device.makeDefaultLibrary()!
        let vertexFunction: MTLFunction = library.makeFunction(name: "vertex_main")!
        let fragmentFunction: MTLFunction = library.makeFunction(name: "fragment_main")!
        
        //
        
        super.init()
        
        //
        
        mtkView.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
        mtkView.delegate = self
        
        let mdlMesh: MDLMesh = Primitive.makeCube(device: device, size: 1)
        mesh = try! .init(mesh: mdlMesh, device: device)
        
        vertexBuffer = mesh.vertexBuffers[0].buffer
        
        let pipelineDescriptor: MTLRenderPipelineDescriptor = .init()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.vertexDescriptor = try! MTKMetalVertexDescriptorFromModelIOWithError(mdlMesh.vertexDescriptor)
        pipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
        //
        
        let translation: float4x4 = .init(translation: [0, 0.3, 0])
        let rotation: float4x4 = .init(rotation: [0, Float(45).degreesToRadians, 0])
        uniforms.modelMatrix = translation * rotation
        uniforms.viewMatrix = float4x4(translation: [0.8, 0, 0]).inverse
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        let aspect: Float = Float(view.bounds.width) / Float(view.bounds.height)
        let projectionMatrix: float4x4 = .init(projectionFov: Float(45).degreesToRadians, near: 0.1, far: 100, aspect: aspect)
        uniforms.projectionMatrix = projectionMatrix
    }
    
    func draw(in view: MTKView) {
        print(#function, Date())
        
        let descriptor: MTLRenderPassDescriptor = view.currentRenderPassDescriptor!
        let commandBuffer: MTLCommandBuffer = Self.commandQueue.makeCommandBuffer()!
        let renderEncoder: MTLRenderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
        
        //
        
//        timer += 0.05
//        var currentTime: Float = sin(timer)
//        renderEncoder.setVertexBytes(&currentTime, length: MemoryLayout<Float>.stride, index: 1)
        
        //
        
        renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
        
        timer += 0.05
        uniforms.viewMatrix = float4x4.identity()
        uniforms.modelMatrix = float4x4(rotationY: sin(timer))
        
        uniforms.viewMatrix = float4x4(translation: [0, 0, -3]).inverse
        
        //
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        mesh.submeshes.forEach { submesh in
            renderEncoder.drawIndexedPrimitives(type: .triangle,
                                                indexCount: submesh.indexCount,
                                                indexType: submesh.indexType,
                                                indexBuffer: submesh.indexBuffer.buffer,
                                                indexBufferOffset: submesh.indexBuffer.offset)
        }
        
        renderEncoder.endEncoding()
        let drawable: MTLDrawable = view.currentDrawable!
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
