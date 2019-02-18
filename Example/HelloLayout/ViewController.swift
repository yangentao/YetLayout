//
//  ViewController.swift
//  HelloLayout
//
//  Created by entaoyang on 2019-02-19.
//  Copyright © 2019 yet.net. All rights reserved.
//

import UIKit
import YetLayout

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view, typically from a nib.
		let lb = UILabel(frame: CGRect.zero)
		self.view.addSubview(lb)

		lb.layout.centerParent().heightText().width(200)

		lb.text = "Hello"
		lb.textAlignment = .center
		lb.backgroundColor = .green


	}


}
