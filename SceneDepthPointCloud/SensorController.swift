//
//  SensorController.swift
//  AV Foundation
//
//  Created by Min Young Chang on 1/4/21.
//  Copyright © 2021 Pranjal Satija. All rights reserved.
//

import CoreMotion
import UIKit

class SensorController {
    let UPDATE_INTERVAL = 0.1
    let motionManager = CMMotionManager()
    
    var time: Date!
    var timestamp: Double!
    
    var roll: Double!
    var pitch: Double!
    var yaw: Double!
    
    var accel_x: Double!
    var accel_y: Double!
    var accel_z: Double!
    
    var gyro_x: Double!
    var gyro_y: Double!
    var gyro_z: Double!
    
    var collectedData: [Dictionary<String, AnyObject>] =  Array()
    var uptime = ProcessInfo.processInfo.systemUptime
    
    func startMotionSensor() {
        motionManager.deviceMotionUpdateInterval  = UPDATE_INTERVAL
        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (data, error) in
            if let trueData = data {
                self.timestamp = trueData.timestamp
                self.timestamp -=  self.uptime + (5*3600)   // time adjustment to EST
                self.time = Date(timeIntervalSinceNow: self.timestamp)
                
                self.roll = trueData.attitude.roll
                self.pitch = trueData.attitude.pitch
                self.yaw = trueData.attitude.yaw
                
                self.accel_x = trueData.userAcceleration.x
                self.accel_y = trueData.userAcceleration.y
                self.accel_z = trueData.userAcceleration.z
                
                self.gyro_x = trueData.rotationRate.x
                self.gyro_y = trueData.rotationRate.y
                self.gyro_z = trueData.rotationRate.z
            }
        }
    }
    
    func collectData() {
        var current_data = Dictionary<String, AnyObject>()
        
        current_data.updateValue(self.time as AnyObject, forKey: "time")
        
        current_data.updateValue(self.roll as AnyObject, forKey: "roll")
        current_data.updateValue(self.pitch as AnyObject, forKey: "pitch")
        current_data.updateValue(self.yaw as AnyObject, forKey: "yaw")
        
        current_data.updateValue(self.accel_x as AnyObject, forKey: "acceleration_x")
        current_data.updateValue(self.accel_y as AnyObject, forKey: "acceleration_y")
        current_data.updateValue(self.accel_z as AnyObject, forKey: "acceleration_z")
        
        current_data.updateValue(self.gyro_x as AnyObject, forKey: "gyro_x")
        current_data.updateValue(self.gyro_y as AnyObject, forKey: "gyro_y")
        current_data.updateValue(self.gyro_z as AnyObject, forKey: "gyro_z")
        
        self.collectedData.append(current_data)
    }
    
    func createCSV(from recArray:[Dictionary<String, AnyObject>]) -> String {
        var csvString = "\("time"), \("roll"), \("pitch"), \("yaw"), \("acceleration_x"), \("acceleration_y"), \("acceleration_z"), \("gyro_x"), \("gyro_y"), \("gyro_z")\n"
        
        for dct in recArray {
            csvString = csvString.appending("\(String(describing: dct["time"]!)), \(String(describing: dct["roll"]!)) ,\(String(describing: dct["pitch"]!)), \(String(describing: dct["yaw"]!)), \(String(describing: dct["acceleration_x"]!)), \(String(describing: dct["acceleration_y"]!)), \(String(describing: dct["acceleration_z"]!)), \(String(describing: dct["gyro_x"]!)), \(String(describing: dct["gyro_y"]!)), \(String(describing: dct["gyro_z"]!))\n")
        }
        
        return csvString
    }
}
