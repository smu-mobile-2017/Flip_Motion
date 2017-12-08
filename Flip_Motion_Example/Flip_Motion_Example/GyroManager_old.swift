//
//  GyroManager.swift
//  Flip_Motion_Example
//
//  Created by Justin Wilson on 11/31/17.
//  Copyright © 2017 Justin Wilson. All rights reserved.
//

import Foundation
import CoreMotion

class GyroManager {
	typealias Callback = ()->Void
	private var flipUpCallback: Callback?
	private var flipDownCallback: Callback?
	
	//CMMotion Manager
	var manager: CMMotionManager? = nil
	
	//Waiting Flag
	var isWaitingForMoition = false
	
	init() {
		//Setup CoreMotion
		let cmQueue = OperationQueue()
		manager = CMMotionManager()
	
		//Setup CoreMotion flip detection and start polling
		if manager!.isDeviceMotionAvailable {
			manager!.deviceMotionUpdateInterval = 0.02
			manager!.startDeviceMotionUpdates(to: cmQueue) {
				[weak self] (data: CMDeviceMotion?, error: Error?) in
				
				if self?.isWaitingForMoition == true {
					
					if let x = data?.rotationRate.x, //Lateral axis rotation rate
						let z = data?.userAcceleration.z { //Normal axis acceleration
						
						if z < -0.4 && x < -6.0 {
							//Flip up
							self!.flipDispatch(callbackFunc: self?.flipUpCallback)
							
							//Debug print statments
							print("Flip Up\nx: " + String(x))
							print("z: " + String(z) + "\n")
							
						} else if z > 0.5 && x > 6.0 {
							//Flip down
							self!.flipDispatch(callbackFunc: self?.flipDownCallback)
						
							//Debug print statments
							print("Flip Down\nx: " + String(x))
							print("z: " + String(z) + "\n")
							
						}
					}
				}
			}
		}
		
		//Enable waiting for motion
		isWaitingForMoition = true
	}
	
	private func flipDispatch(callbackFunc callback: Callback?) {
		DispatchQueue.main.async {
			if callback != nil {
				callback!()
			}
	
			self.isWaitingForMoition = false //not waiting for motion - debounce
			
			//Start Timer to resume waiting for motion - debounce (run on main queue)
			Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (t:Timer) in
				self.isWaitingForMoition = true
				print("isWaitingForMoition = true\n")
			})
			/** NOTE: Once an timer is invalidated it cannot be reused per the API,
			    thus a new Timer is created every time. "Once invalidated, timer objects
			    cannot be reused."  An interval timer does not work here. **/
		}
	}
	
	func listen() {
		if self.manager != nil {
			//start the updates
			self.manager!.startGyroUpdates()
			self.manager!.startAccelerometerUpdates()
		} else {
			print("Error: GyroManager not initialized")
		}
	}
	
	func stop() {
		if self.manager != nil {
			//stop the updates
			self.manager!.stopGyroUpdates()
			self.manager!.stopAccelerometerUpdates()
		} else {
			print("Error: GyroManager not initialized")
		}
	}
	
	func onFlipUp(_ callback: @escaping Callback) {
		flipUpCallback = callback
	}
	
	func onFlipDown(_ callback: @escaping Callback) {
		flipDownCallback = callback
	}
}
