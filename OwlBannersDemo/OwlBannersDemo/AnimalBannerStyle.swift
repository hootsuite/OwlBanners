// Copyright 2017 HootSuite Media Inc.

// This file is part of OwlBanners. The full OwlBanners copyright notice,
// including terms governing use, modification, and redistribution, is
// contained in the file LICENSE.md at the root of the source code distribution
// tree.

import Foundation
import UIKit
import OwlBanners

enum AnimalBannerStyle: BannerStyle {
    case cat, dog

    var bannerConfiguration: BannerConfiguration {
        switch self {
        case .cat:
            let nib = UINib(nibName: "CatBannerView", bundle: nil)
            let catBannerView = nib.instantiate(withOwner: nil, options: nil).first as! UIView
            return BannerConfiguration(bannerView: catBannerView, bufferHeight: 30.0, defaultDisplayMetrics: BannerDisplayMetrics(0.5, 4, 0.25))
        case .dog:
            let nib = UINib(nibName: "DogBannerView", bundle: nil)
            let dogBannerView = nib.instantiate(withOwner: nil, options: nil).first as! UIView
            return BannerConfiguration(bannerView: dogBannerView, bufferHeight: 50.0, preferredStatusBarStyle: .lightContent, defaultDisplayMetrics: BannerDisplayMetrics(0.5, 4, 0.25))
        }
    }
}
