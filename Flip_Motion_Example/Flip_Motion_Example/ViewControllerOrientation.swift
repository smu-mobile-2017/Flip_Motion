//
//  ViewController.swift
//  Flip_Motion_Example
//
//  Created by Justin Wilson on 11/29/17.
//  Copyright © 2017 Justin Wilson. All rights reserved.
//

import UIKit
import CoreMotion

class ViewControllerOrientation: UIViewController {
	@IBOutlet var motionLabel: UILabel!
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
	
		
		UIDevice.current.beginGeneratingDeviceOrientationNotifications()
		
		NotificationCenter.default.addObserver(forName: NSNotification.Name.UIDeviceOrientationDidChange,
											   object: nil, queue: nil) { notification in
			print("Orientation Changed!")
			if UIDevice.current.orientation == .faceDown {
				print("Face Down!")
				self.motionLabel.text = "Flip Down"
				self.motionLabel.backgroundColor = UIColor.orange
				
			}	else if UIDevice.current.orientation == .faceUp {
				print("Face Up!")
				self.motionLabel.text = "Flip Up"
				self.motionLabel.backgroundColor = UIColor.blue
			}
		}
		
		
		
	
	}
	
	func detectOrientation() {
		print(UIDevice.current.orientation)
	}
	
	func viewDidCose() {
	}

}

