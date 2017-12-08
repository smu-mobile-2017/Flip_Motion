//
//  GyroManager.swift
//  Flip_Motion_Example
//
//  Created by Justin Wilson on 11/31/17.
//  Copyright © 2017 Justin Wilson. All rights reserved.
//

import Foundation
import CoreMotion
import UIKit

class GyroManager {
	typealias Callback = ()->Void
	private var flipUpCallback: Callback?
	private var flipDownCallback: Callback?
	
	var manager:CMMotionManager
	var stableTheta:Double = 1.4 //assumes vertical
	var previousAttitude:CMAttitude? = nil
	var flippedFlag = 0 // debounce flipped flag
	
	init() {
		let cmQueue = OperationQueue()
		manager = CMMotionManager()
		
		//Setup CoreMotion flip detection and start polling
		guard manager.isDeviceMotionAvailable else {
			print("Warning: device motion unavailable.")
			return
		}
		
		manager.deviceMotionUpdateInterval = 0.09
		
		manager.startDeviceMotionUpdates(to: cmQueue) { (data, error) in
			guard
				let x = data?.rotationRate.x, // Lateral axis rotation rate
				let currentAttitude = data?.attitude //get current attitude, all 3 euler angles
			else {
				print("Warning: could not parse CoreMotion data.")
				return
			}
			
			if self.previousAttitude == nil {
				//save previous
				self.previousAttitude = currentAttitude
				return
			}
			
			//copy currentAttitude for next itteration, currentAttitude will be modified
			let backupAttitude = currentAttitude.copy(with: nil) as! CMAttitude
			
			//calulate the difference between the previous attitude and the present
			currentAttitude.multiply(byInverseOf: self.previousAttitude!)
			let theta = currentAttitude.pitch //this is the difference in pitch
			
			//store backup as previous
			self.previousAttitude = backupAttitude
			
			/* NOTE: x or rotation rate about the x-axis, also known as l, implys direction.
			   Theta is the euler angle for pitch in rads, 90 degrees is ~ 1.57 rads;
			   this makes flip up postive or negative, and down is always postive --
			   between their differences. */
			if self.flippedFlag == 0 && (theta > 0.3 || theta < -0.3) && x < -0.3 {
				// Flip up
				self.flipDispatch(callbackFunc: self.flipUpCallback)
				self.flippedFlag = 10
				// Debug print statments
				print("Flip Up")
				print("theta: " + String(theta))
				print("x: " + String(x) + "\n")
			} else if self.flippedFlag == 0 && theta > 0.3 && x > 0.3  {
				// Flip down
				self.flipDispatch(callbackFunc: self.flipDownCallback)
				self.flippedFlag = 10
				// Debug print statments
				print("Flip Down")
				print("theta: " + String(theta))
				print("x: " + String(x) + "\n")
			} else {
				if self.flippedFlag > 0 {
					self.flippedFlag = self.flippedFlag - 1
				}
			}
		}
	}
	
	private func flipDispatch(callbackFunc callback: Callback?) {
		DispatchQueue.main.async {
			if let callback = callback { callback() }
		}
	}
	
	func listen() {
		manager.startGyroUpdates()
		manager.startAccelerometerUpdates()
	}
	
	func stop() {
		manager.stopGyroUpdates()
		manager.stopAccelerometerUpdates()
	}
	
	func onFlipUp(_ callback: @escaping Callback) {
		flipUpCallback = callback
	}
	
	func onFlipDown(_ callback: @escaping Callback) {
		flipDownCallback = callback
	}
}
