import MetalKit
import PlaygroundSupport

// set up View
device = MTLCreateSystemDefaultDevice()!
let frame = NSRect(x: 0, y: 0, width: 600, height: 600)
let view = MTKView(frame: frame, device: device)
view.clearColor = MTLClearColor(red: 1, green: 1, blue: 0.8, alpha: 1)
view.device = device

// Metal set up is done in Utility.swift

// set up render pass
guard let drawable = view.currentDrawable,
  let descriptor = view.currentRenderPassDescriptor,
  let commandBuffer = commandQueue.makeCommandBuffer(),
  let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {
    fatalError()
}
renderEncoder.setRenderPipelineState(pipelineState)

// drawing code here
//var vertices: [SIMD3<Float>] = [[0, 0, 0.5]]
var vertices: [SIMD3<Float>] = [
    [-0.7, 0.8, 1],
    [-0.7, -0.4, 1],
    [0.4, 0.2, 1]
]

let originalBuffer: MTLBuffer = device.makeBuffer(length: vertices.count, options: [])!
renderEncoder.setVertexBuffer(originalBuffer, offset: 0, index: 0)

renderEncoder.drawPrimitives(type: .point, vertexStart: 0, vertexCount: vertices.count)

//

var matrix: simd_float4x4 = matrix_identity_float4x4
//vertices[0] += [0.3, -0.4, 0]
matrix.columns.3 = [0.3, -0.4, 0, 1]
//vertices = vertices.map {
//    let vertex: SIMD4<Float> = matrix * float4($0, 1)
//    return [vertex.x, vertex.y, vertex.z]
//}
//renderEncoder.setVertexBytes(&vertices, length: MemoryLayout<SIMD3<Float>>.stride * vertices.count, index: 0)
renderEncoder.setVertexBytes(&matrix, length: MemoryLayout<float4x4>.stride, index: 1)

var transformedBuffer: MTLBuffer! = device.makeBuffer(bytes: &vertices, length: MemoryLayout<SIMD3<Float>>.stride * vertices.count, options: [])
renderEncoder.setVertexBuffer(transformedBuffer, offset: 0, index: 0)
renderEncoder.setFragmentBytes(&redColor, length: MemoryLayout<float4>.stride, index: 0)
renderEncoder.drawPrimitives(type: .lineStrip, vertexStart: 0, vertexCount: vertices.count)

// Scaling
//let scaleX: Float = 1.2
//let scaleY: Float = 0.5
//matrix = float4x4(
//    [scaleX, 0, 0, 0],
//    [0, scaleY, 0, 0],
//    [0, 0, 1, 0],
//    [0, 0, 0, 1]
//)
//
//renderEncoder.setVertexBuffer(device.makeBuffer(bytes: &vertices, length: MemoryLayout<SIMD3<Float>>.stride * vertices.count), offset: 0, index: 0)
////renderEncoder.setVertexBytes(&vertices, length: MemoryLayout<SIMD3<Float>>.stride * vertices.count, index: 0)
//renderEncoder.setVertexBytes(&matrix, length: MemoryLayout<float4x4>.stride, index: 1)
//renderEncoder.setFragmentBytes(&redColor, length: MemoryLayout<float4>.stride, index: 0)
//renderEncoder.drawPrimitives(type: .lineStrip, vertexStart: 0, vertexCount: vertices.count)

// Rotation

let angle: Float = (.pi) / 2.0
matrix = matrix_identity_float4x4

matrix.columns.0 = [cos(angle), -sin(angle), 0, 0]
matrix.columns.1 = [sin(angle), cos(angle), 0 ,0]

renderEncoder.setVertexBytes(&vertices, length: MemoryLayout<SIMD3<Float>>.stride * vertices.count, index: 0)
renderEncoder.setVertexBytes(&matrix, length: MemoryLayout<float4x4>.stride, index: 1)
renderEncoder.setFragmentBytes(&redColor, length: MemoryLayout<float4>.stride, index: 0)
renderEncoder.drawPrimitives(type: .lineStrip, vertexStart: 0, vertexCount: vertices.count)

// Concatenation

var distanceVector: SIMD4<Float> = [vertices.last!.x, vertices.last!.y, vertices.last!.z, 1]
var translate: simd_float4x4 = matrix_identity_float4x4
translate.columns.3 = distanceVector
var rotate: simd_float4x4 = matrix_identity_float4x4
rotate.columns.0 = [cos(angle), -sin(angle), 0, 0]
rotate.columns.1 = [sin(angle), cos(angle), 0, 0]

matrix = translate * rotate * translate.inverse

renderEncoder.setVertexBytes(&vertices, length: MemoryLayout<SIMD3<Float>>.stride * vertices.count, index: 0)
renderEncoder.setVertexBytes(&matrix, length: MemoryLayout<float4x4>.stride, index: 1)
renderEncoder.setFragmentBytes(&redColor, length: MemoryLayout<float4>.stride, index: 0)
renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)

//

renderEncoder.endEncoding()
commandBuffer.present(drawable)
commandBuffer.commit()

PlaygroundPage.current.liveView = view
