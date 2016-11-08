//
//  DogBannerView.swift
//  BannerPrototype
//
//  Created by Brett Stover on 9/25/15.
//  Copyright © 2015 Brett Stover. All rights reserved.
//

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
            titleLabel.hidden = (newValue == "")
        }
    }
}
