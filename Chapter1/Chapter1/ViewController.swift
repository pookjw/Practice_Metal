//
//  ViewController.swift
//  Chapter1
//
//  Created by Jinwoo Kim on 7/16/22.
//

import UIKit
import MetalKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize Metal
        guard let device: MTLDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("GPU is not supported")
        }
        
        let frame: CGRect = .init(x: .zero, y: .zero, width: 600, height: 600)
        let mtkView: MTKView = .init(frame: frame, device: device)
        mtkView.clearColor = MTLClearColor(red: 0.4, green: 1, blue: 0.8, alpha: 1)
        view.addSubview(mtkView)
        mtkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mtkView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mtkView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mtkView.widthAnchor.constraint(equalToConstant: frame.width),
            mtkView.heightAnchor.constraint(equalToConstant: frame.height)
        ])
        
        // Load a model
        let allocator: MTKMeshBufferAllocator = .init(device: device)
        
        // Sphere
//        let mdlMesh: MDLMesh = .init(sphereWithExtent: [0.75, 0.75, 0.75],
//                                     segments: [100, 100],
//                                     inwardNormals: false,
//                                     geometryType: .triangles,
//                                     allocator: allocator)
        
        // Cone
//        let mdlMesh: MDLMesh = .init(coneWithExtent: [1, 1, 1],
//                                     segments: [10, 10],
//                                     inwardNormals: false,
//                                     cap: true,
//                                     geometryType: .triangles,
//                                     allocator: allocator)
        
        // Train
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
        let mdlMesh: MDLMesh = asset.childObjects(of: MDLMesh.self).first as! MDLMesh
        
        //
        
        let mesh: MTKMesh = try! .init(mesh: mdlMesh, device: device)
        
        // Export to file if needed!
//        let asset: MDLAsset = .init()
//        asset.add(mdlMesh)
//
//        guard MDLAsset.canExportFileExtension("obj") else {
//            fatalError()
//        }
//
//        let baseUrl: URL
//        let objUrl: URL
//        let mtlUrl: URL
//
//        if #available(iOS 16.0, *) {
//            baseUrl = FileManager.default.temporaryDirectory
//            objUrl = baseUrl.appending(path: "primitive").appendingPathExtension("obj")
//            mtlUrl = baseUrl.appending(path: "primitive").appendingPathExtension("mtl")
//        } else {
//            baseUrl = FileManager.default.temporaryDirectory
//            objUrl = baseUrl.appendingPathComponent("primitive").appendingPathExtension("obj")
//            mtlUrl = baseUrl.appendingPathComponent("primitive").appendingPathExtension("mtl")
//        }
//        try! asset.export(to: objUrl)
//
//        print("#####")
//        print(objUrl)
//        print(String(data: try! Data(contentsOf: objUrl), encoding: .utf8)!)
//        print("#####")
//        print(mtlUrl)
//        print(String(data: try! Data(contentsOf: mtlUrl), encoding: .utf8)!)
//        print("#####")
        
        //
        
        guard let commandQueue: MTLCommandQueue = device.makeCommandQueue() else {
            fatalError("Could not create a command queue")
        }
        
        let shaderUrl: URL = Bundle.main.url(forResource: "default", withExtension: "metallib")!
        let library: MTLLibrary = try! device.makeLibrary(URL: shaderUrl)
        let vertexFunction: MTLFunction = library.makeFunction(name: "vertex_main")!
        let fragmentFunction: MTLFunction = library.makeFunction(name: "fragment_main")!
        
        // Set up the pipeline
        
        let pipelineDescriptor: MTLRenderPipelineDescriptor = .init()
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        
        pipelineDescriptor.vertexDescriptor = try! MTKMetalVertexDescriptorFromModelIOWithError(mesh.vertexDescriptor)
        
        // true
        print(pipelineDescriptor.vertexDescriptor?.isEqual(vertexDescriptor))
        
        let pipelineState: MTLRenderPipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
        // Render
        let commandBuffer: MTLCommandBuffer = commandQueue.makeCommandBuffer()!
        let renderPassDescriptor: MTLRenderPassDescriptor = mtkView.currentRenderPassDescriptor!
        let renderEncoder: MTLRenderCommandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(mesh.vertexBuffers[0].buffer, offset: 0, index: 0)
        
//        renderEncoder.setTriangleFillMode(.lines)
        
        mesh.submeshes.forEach { submesh in
            renderEncoder.drawIndexedPrimitives(type: .line,
                                                indexCount: submesh.indexCount,
                                                indexType: submesh.indexType,
                                                indexBuffer: submesh.indexBuffer.buffer,
                                                indexBufferOffset: submesh.indexBuffer.offset)
        }
        
        renderEncoder.endEncoding()
        let drawable: CAMetalDrawable = mtkView.currentDrawable!
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }


}

