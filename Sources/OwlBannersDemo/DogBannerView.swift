// Copyright 2017 HootSuite Media Inc.

// This file is part of OwlBanners. The full OwlBanners copyright notice,
// including terms governing use, modification, and redistribution, is
// contained in the file LICENSE.md at the root of the source code distribution
// tree.

import UIKit
import OwlBanners

class DogBannerView: UIView, BannerView {

    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = ""
        }
    }

    var title: String {
        get { return titleLabel.text ?? "" }
        set {
            titleLabel.text = newValue
            titleLabel.isHidden = (newValue == "")
        }
    }
}
