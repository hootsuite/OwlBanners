//
//  AnimalBannerStyle.swift
//  OwlBannersDemo
//
//  Created by Brett Stover on 2015-12-06.
//  Copyright © 2015 Hootsuite. All rights reserved.
//

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
