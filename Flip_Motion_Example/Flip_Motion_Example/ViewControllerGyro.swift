//
//  ViewController.swift
//  Flip_Motion_Example
//
//  Created by Justin Wilson on 11/29/17.
//  Copyright © 2017 Justin Wilson. All rights reserved.
//

import UIKit
import CoreMotion

class ViewControllerGyro: UIViewController {
	@IBOutlet var motionLabel: UILabel!
	
	var manager: CMMotionManager? = nil
	var isWaitingForMoition = false
	
	override func viewDidLoad() {
		super.viewDidLoad() //Super
		
		//setup CMMotionManager
		let cmQueue = OperationQueue()
		manager = CMMotionManager()
		manager!.startGyroUpdates()
		manager!.startAccelerometerUpdates()
		
		//motion flag
		isWaitingForMoition = true
		
		//Setupt CoreMotion flip detection
		if manager!.isDeviceMotionAvailable {
			manager!.deviceMotionUpdateInterval = 0.02
			manager!.startDeviceMotionUpdates(to: cmQueue) {
				[weak self] (data: CMDeviceMotion?, error: Error?) in
				
				if self?.isWaitingForMoition == true {
					
					if let x = data?.rotationRate.x,//lateral axis rotation
						let z = data?.userAcceleration.z,
						z < -0.9 && x < -8.0 {
						
						DispatchQueue.main.async {
							self?.motionLabel.text = "Flip Up"
							self?.motionLabel.backgroundColor = UIColor.blue
							print("Flip Up\nx:" + String(x))
							print("z: " + String(z))
							
							Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (t:Timer) in
								self?.isWaitingForMoition = true
								print("isWaitingForMoition = true")
							})
							self?.isWaitingForMoition = false
						}
					} else if let x = data?.rotationRate.x, //lateral axis rotation
						let z = data?.userAcceleration.z,
						z > 1.0 && x > 8.0 {
						
						DispatchQueue.main.async {
							self?.motionLabel.text = "Flip Down"
							self?.motionLabel.backgroundColor = UIColor.orange
							print("Flip Down\nx:" + String(x))
							print("z: " + String(z))
						
							Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (t:Timer) in
								self?.isWaitingForMoition = true
								print("isWaitingForMoition = true")
							})
							self?.isWaitingForMoition = false
						}
						
					}
				}
				
			}
		}
	}
	
	func viewDidCose() {
		manager!.stopGyroUpdates()
		manager!.stopAccelerometerUpdates()
	}

}

