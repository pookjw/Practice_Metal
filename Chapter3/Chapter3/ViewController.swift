//
//  ViewController.swift
//  Chapter3
//
//  Created by Jinwoo Kim on 7/17/22.
//

import Cocoa
import MetalKit

class ViewController: NSViewController {
    private var renderer: Renderer?

    override func viewDidLoad() {
        super.viewDidLoad()

        let mtkView: MTKView = view as! MTKView
        renderer = .init(mtkView: mtkView)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

