//
//  ViewController.swift
//  Flip_Motion_Example
//
//  Created by Justin Wilson on 11/29/17.
//  Copyright © 2017 Justin Wilson. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
	@IBOutlet var motionLabel: UILabel!
	
	var manager: CMMotionManager? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let queue = OperationQueue()
		manager = CMMotionManager()
		manager!.startAccelerometerUpdates()
		
		if manager!.isDeviceMotionAvailable {
			manager!.deviceMotionUpdateInterval = 0.02
			manager!.startDeviceMotionUpdates(to: queue) {
				[weak self] (data: CMDeviceMotion?, error: Error?) in
				if let z = data?.userAcceleration.z,
					z < -2.0 {
					DispatchQueue.main.async {
						self?.motionLabel.text = "Flip Up"
						self?.motionLabel.backgroundColor = UIColor.blue
						print("Flip Up")
					}
				} else if let z = data?.userAcceleration.z,
					z > 2.0 {
					DispatchQueue.main.async {
						self?.motionLabel.text = "Flip Down"
						self?.motionLabel.backgroundColor = UIColor.orange
						print("Flip Down")
					}
				}
			
			}
		}
	}
	
	func viewDidCose() {
		manager!.stopAccelerometerUpdates()
	}

}

