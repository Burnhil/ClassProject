//
//  ViewController.swift
//  ClassProject
//
//  Created by student on 2/12/19.
//  Copyright © 2019 student. All rights reserved.
//

//importing coremotion kit
import CoreMotion
import UIKit

class ViewController: UIViewController {
    
    
    //setting up motionManager variable
    let motionManager = CMMotionManager()
    
    //set up labels for testing variables
    @IBOutlet weak var accZ: UILabel!
    @IBOutlet weak var accX: UILabel!
    @IBOutlet weak var accY: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let accelQueue : OperationQueue = OperationQueue()
        // Do any additional setup after loading the view, typically from a nib.
        motionManager.accelerometerUpdateInterval = 1
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {(accelData: CMAccelerometerData?, errorOC: Error?) in
            print(accelData!.acceleration.z)
            
            //setting up testing for acceleration variables
            self.accZ.text = String(accelData!.acceleration.z)
            print(accelData!.acceleration.x)
            self.accX.text = String(accelData!.acceleration.x)
            print(accelData!.acceleration.y)
            self.accX.text = String(accelData!.acceleration.y)
            

        })

        motionManager.startAccelerometerUpdates()
        if let accelerometerData = motionManager.accelerometerData {
        }
        
        print(motionManager)
        
    }


}

