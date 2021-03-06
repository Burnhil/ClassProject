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

//corelocation added for future build using gps for speed source
import CoreLocation

//setting up struct to store accelerometer info
struct TimeIntervalGoingFast {
    var startDateTime : Date
    var endDateTime : Date
    var averageSpeed : Double
    var maxSpeed : Double
    var minSpeed : Double
    var isUsed : Bool
}

/*      Corelocation function to use gps for speed source future builds
func startTest(){
    var lm = CLLocationManager()
    var courseSpeed = lm.location?.speed.magnitude
    var speed = couresSpeed?.magnitude
    
}
*/

class ViewController: UIViewController {
    
    //initialize struct to array
    var times : [TimeIntervalGoingFast] = []
    
    //setting up motionManager variable
    let motionManager = CMMotionManager()
    
    //set up labels for testing variables from accelerometer to output labels
    @IBOutlet weak var accZ: UILabel!
    @IBOutlet weak var accX: UILabel!
    @IBOutlet weak var accY: UILabel!
    @IBOutlet weak var countTimes: UILabel!
    @IBOutlet weak var speed1: UILabel!
    
    //initialize variable to use to convert x y z axis from m/s^2 to mph
    var gaccZ = Double()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //starting operation queue
        let accelQueue : OperationQueue = OperationQueue()
        
        //setting up variables to be measured by app/stored
        var seconds = 0
        var speed = 0.0
        var x = 0.0
        var y = 0.0
        var z = 0.0
        var min = 99999999.0
        var max = -9999999.0
        
        var speedingInstance : TimeIntervalGoingFast = TimeIntervalGoingFast(startDateTime: Date(timeIntervalSinceNow: TimeInterval(0)), endDateTime: Date(timeIntervalSinceNow: TimeInterval(0)), averageSpeed: 0.0, maxSpeed: 0.0, minSpeed: 0.0, isUsed: false)
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //starting accelerometer and motionmanager initialize 1 second increments
        motionManager.accelerometerUpdateInterval = 1
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler: {(accelData: CMAccelerometerData?, errorOC: Error?) in
            
            //printing to console test variables
            print(accelData!.acceleration.z)
            print("Testing the intervals")
            
            //setting up testing for acceleration variables
            //printing to variables
            self.accZ.text = String(accelData!.acceleration.z)
            print(accelData!.acceleration.x)
            //self.accZ.text = String(accelData!.acceleration.z)
            self.accX.text = String(accelData!.acceleration.x)
            print(accelData!.acceleration.y)
            self.accY.text = String(accelData!.acceleration.y)
            
            //count iterations and send to label for testing
            self.countTimes.text = String(self.times.count)
            
            
            /*  original code to use for conversion m/s^2 to mph
            https://www.thecalculatorsite.com/conversions/acceleration.php <---used this web site for formula info
            showes m/s2 converted to mph/s = conversion rate 1 : 2.2369362920544
            self.gaccZ = 2.2369362920544 * accelData!.acceleration.x
            */
            
            //set up variables from accelerometer for x y z
            x = accelData!.acceleration.x
            y = accelData!.acceleration.y
            z = accelData!.acceleration.z
            //using x y z variables with formula to calculate data output for speed
            self.gaccZ = pow(pow(x, 2) + pow(y, 2) + pow(z, 2), 0.5) * 21.94 - 21.94
            
                //sending speed calculation out to label
                speed = abs(self.gaccZ)
                self.speed1.text = String(speed)
            
                //setting up if statements to start capturing data
                //setting max/min speed per tick to be recorded
                if (speed > max) {
                    max = speed
                }
                if(speed < min) {
                    min = speed
                }
            
                //capturing data greater then 10mph/s in struct to array
                if (speed > 10.0) {
                    seconds = seconds + 1
                    if(speedingInstance.isUsed == false) {
                        speedingInstance.startDateTime = Date(timeIntervalSinceNow: TimeInterval(0))
                        speedingInstance.maxSpeed = max
                        speedingInstance.minSpeed = min
                        speedingInstance.isUsed = true
                        
                    } else {
                        speedingInstance.endDateTime = Date(timeIntervalSinceNow: TimeInterval(0))
                        speedingInstance.averageSpeed = speed / Double(seconds)
                        speedingInstance.minSpeed = min
                        speedingInstance.maxSpeed = max
                    }
                    
                    //storing struct in array for furture use
                } else {
                    if(speedingInstance.isUsed == true) {
                        //possible fail point appending struct to array
                        self.times.append(speedingInstance)
                        speedingInstance.isUsed = false
                       
                        //This string of code it to store the speedingInstance in a text file
                        let file = "file.txt"
                        //setting up string to be stored in file.text
                        let text = "MaxSpeed: " + String(speedingInstance.maxSpeed) + "MinSpeed: " + String(speedingInstance.minSpeed) + String(speedingInstance.averageSpeed)
                        
                        //setting up filemanager and directory path for storage
                        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                        let fileURL = dir.appendingPathComponent(file)
                            
                            //writing to actual text file
                            do {
                                try text.write(to: fileURL, atomically: false, encoding: .utf8)
                            }
                            catch { print("Error accured unable to write to text file:", error) }
        
                            //could pass this out if needed // currently set to print to console
                            do {
                                let text2 = try String(contentsOf: fileURL, encoding: .utf8)
                                print(text2)
                            }
                            catch { print("Error accured unable to write to text file:", error) }
 
                        }
                    }
                }
            }
    )

        //calling accelerometer through motion manager
        //motionManager.startAccelerometerUpdates()
        //motionManager.
        if let accelerometerData = motionManager.accelerometerData {
        }
        
        //testing print calls to verify motionmanager and increments for seconds
        print(motionManager)
        print(seconds)
        
    }
}
