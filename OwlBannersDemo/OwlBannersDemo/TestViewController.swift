// Copyright 2017 HootSuite Media Inc.

// This file is part of OwlBanners. The full OwlBanners copyright notice,
// including terms governing use, modification, and redistribution, is
// contained in the file LICENSE.md at the root of the source code distribution
// tree.

import UIKit

//swiftlint:disable line_length

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .purple

        let label = UILabel()
        label.text = NSLocalizedString("View controller will dismiss in 4 seconds.", comment: "Test view controller dismissal message.")
        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|[label]|", options: [.alignAllCenterY], metrics: nil, views: ["label": label])
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]|", options: [], metrics: nil, views: ["label": label])

        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(4 * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
