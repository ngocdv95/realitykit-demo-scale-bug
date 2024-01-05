//
//  ContentView.swift
//  DemoRealityBug
//
//  Created by Virtual Try On on 05/01/2024.
//

import SwiftUI
import RealityKit

func ChangeMaterial(e: Entity) {
    // Make sure the entity has a ModelComponent.
    if var modelComponent: ModelComponent = e.components[ModelComponent.self] {
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Error creating default metal device.")
        }
        guard let library = device.makeDefaultLibrary() else {
            fatalError("load library error.")
        }
        
        let emptyGeometry = CustomMaterial.GeometryModifier(named: "emptyGeometryModifier", in: library)
        

        // Loop through the entity's materials and replace the existing material with one based on the original material.
        guard let customMaterials = try? modelComponent.materials.map({ material -> CustomMaterial in
            let customMaterial = try CustomMaterial(from: material, geometryModifier: emptyGeometry)
            return customMaterial
        }) else {
            print("get material component error")
            return
        }
        modelComponent.materials = customMaterials
        e.components[ModelComponent.self] = modelComponent
    }
    
    if e.children.count > 0 {
        e.children.forEach { c in
            ChangeMaterial(e: c)
        }
    }
}

struct ContentView: View {
    var body: some View {
        ARViewContainer()
            .edgesIgnoringSafeArea(.all)
    }
}

// MARK: AR VIEW DEFIEND
struct ARViewContainer: UIViewRepresentable {
    // private variable
    let modelAnchor = AnchorEntity(world: [0,-1.5,1.8])
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeUIView(context: Context) -> ARView {
#if targetEnvironment(simulator)
        let arView = ARView(frame: .zero)
#else
        let arView = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: false)
#endif
        arView.environment.background = ARView.Environment.Background.color(.gray)
        arView.renderOptions.insert(.disableMotionBlur)
        arView.renderOptions.insert(.disableHDR)
        arView.renderOptions.insert(.disableCameraGrain)
        arView.renderOptions.insert(.disableDepthOfField)
        arView.renderOptions.insert(.disableGroundingShadows)
        arView.renderOptions.insert(.disableFaceMesh)
        arView.renderOptions.insert(.disablePersonOcclusion)
        
        do {
            let modelMesh = try Entity.load(named: "GUMAC_DC12087_1_M")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                ChangeMaterial(e: modelMesh)
            }
            
            modelAnchor.addChild(modelMesh)
            arView.scene.addAnchor(modelAnchor)
        } catch {
            
        }
        
        return arView
    }
}

#Preview {
    ContentView()
}
