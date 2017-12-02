//
//  ViewController.swift
//  Flip_Motion_Example
//
//  Created by Justin Wilson on 11/29/17.
//  Copyright © 2017 Justin Wilson. All rights reserved.
//

import UIKit
import CoreMotion

class ViewControllerGyroManager: UIViewController {
	@IBOutlet var motionLabel: UILabel!
	
	var gyroManager: GyroManager? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//Setup
		gyroManager = GyroManager()
		gyroManager!.onFlipUp(self.onFlipUp)
		gyroManager!.onFlipDown(self.onFlipDown)
		
		//Start listening
		gyroManager?.listen()
		
	}
	
	func viewDidCose() {
		//Stop Listening
		gyroManager?.stop()
	}
	
	func onReset() {
		self.motionLabel.text = " "
		self.motionLabel.backgroundColor = UIColor.white
	}

	func onFlipUp() {
		print("Callback - FlipUp")
		self.motionLabel.text = "Flip Up"
		self.motionLabel.backgroundColor = UIColor.blue
		Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { (t:Timer) in
			self.onReset() //Reset the screen
		})
	}
	
	func onFlipDown() {
		print("Callback - FlipDown")
		self.motionLabel.text = "Flip Down"
		self.motionLabel.backgroundColor = UIColor.orange
		Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (t:Timer) in
			self.onReset() //Reset the screen
		})
	}

}

