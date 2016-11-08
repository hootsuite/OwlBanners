//
//  TestViewController.swift
//  BannerPrototype
//
//  Created by Brett Stover on 9/22/15.
//  Copyright © 2015 Hootsuite. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .purpleColor()

        let label = UILabel()
        label.text = NSLocalizedString("View controller will dismiss in 4 seconds.", comment: "Test view controller dismissal message.")
        label.textAlignment = .Center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|[label]|", options: [.AlignAllCenterY], metrics: nil, views: ["label" : label])
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: [], metrics: nil, views: ["label" : label])

        NSLayoutConstraint.activateConstraints(horizontalConstraints + verticalConstraints)

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4 * NSEC_PER_SEC)), dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
