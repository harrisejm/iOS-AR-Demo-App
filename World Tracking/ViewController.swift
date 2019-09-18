//
//  ViewController.swift
//  World Tracking
//
//  Created by Eddie Harris on 9/14/19.
//  Copyright © 2019 Eddie Harris. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.autoenablesDefaultLighting = true
    }

    @IBOutlet weak var sceneView: ARSCNView!
    let configuation = ARWorldTrackingConfiguration()
    
    var nodeGreen = SCNNode()
    var nodeBlue = SCNNode()
    var nodeRed = SCNNode()
    var nodeYellow = SCNNode()
    var green: Bool = false
    var blue: Bool = false
    var red: Bool = false
    var yellow: Bool = false
    
    func changeGreen(_ addBlock: Bool){
        self.green = addBlock
    }
    func changeBlue(_ addBlock: Bool){
        self.blue = addBlock
    }
    
    func changeRed(_ addBlock: Bool){
        self.red = addBlock
    }
    func changeYellow(_ addBlock: Bool){
        self.yellow = addBlock
    }

    var vector : [[Float]] = [[0,0,0],[0,0,0.1],[0.1,0,0],[0.1,0,0.1]]
    
    func blockAddRemove(_ block: Bool, _ node : SCNNode, _ vector : [Float], _ addRemoveColorArr: (Bool) -> (), _ color : UIColor){
        if block == false {
            node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03)
            node.geometry?.firstMaterial?.specular.contents = UIColor.orange
            node.geometry?.firstMaterial?.diffuse.contents = color
            node.position = SCNVector3(vector[0],vector[1],vector[2])
            self.sceneView.scene.rootNode.addChildNode(node)
            addRemoveColorArr(true)
        } else {
            node.removeFromParentNode()
            addRemoveColorArr(false)
        }
    }
    
    @IBAction func greenBlock(_ sender: UIButton) {
        self.blockAddRemove(self.green,self.nodeGreen,self.vector[0],self.changeGreen,UIColor.green)
    }
    
    @IBAction func blueBlock(_ sender: UIButton) {
        self.blockAddRemove(self.blue,self.nodeBlue,self.vector[1],self.changeBlue,UIColor.blue)
    }
    
    @IBAction func redBlock(_ sender: UIButton) {
        self.blockAddRemove(self.red,self.nodeRed,self.vector[2],self.changeRed,UIColor.red)
    }
    
    @IBAction func yellowBlock(_ sender: UIButton) {
        self.blockAddRemove(self.yellow,self.nodeYellow,self.vector[3],self.changeYellow,UIColor.yellow)
    }
    
    @IBAction func reset(_ sender: UIButton) {
        self.restartSession()
    }
    
    //reset world tracking
    func restartSession(){
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node,_) in
            node.removeFromParentNode()
        }
        self.sceneView.session.run(configuation, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func randomBallon(_ color : UIColor){
        
        let node = SCNNode()
        let w = randomNumbers(firstNum: 0.01, secondNum: 0.2)
        
        node.geometry = SCNBox(width: w, height: w, length: w, chamferRadius: 0.3)
        node.geometry?.firstMaterial?.specular.contents = UIColor.orange
        node.geometry?.firstMaterial?.diffuse.contents = color
        
        let x = randomNumbers(firstNum: -3.0, secondNum: 3.0)
        let y = randomNumbers(firstNum: -0.8, secondNum: 3.0)
        let z = randomNumbers(firstNum: -3.0, secondNum: 3.0)
        
        node.position = SCNVector3(x,y,z)
        self.sceneView.scene.rootNode.addChildNode(node)
    }
    
    @IBAction func ballons(_ sender: UIButton) {
        let colorArr = [UIColor.green,UIColor.blue,UIColor.red,UIColor.yellow]
        var i = 0
        while i < 4 {
            self.randomBallon(colorArr[i])
            self.randomBallon(colorArr[i])
            self.randomBallon(colorArr[i])
            i+=1
        }
    }

    func randomNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
}

extension Int {
    var degreesToRadians: Double { return Double(self) * .pi/180 }
}
