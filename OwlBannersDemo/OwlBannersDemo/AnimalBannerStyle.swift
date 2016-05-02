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
    case Cat, Dog
    
    var bannerConfiguration: BannerConfiguration {
        switch (self) {
        case .Cat:
            let nib = UINib(nibName: "CatBannerView", bundle: nil)
            let catBannerView = nib.instantiateWithOwner(nil, options: nil).first as! UIView
            return BannerConfiguration(bannerView: catBannerView, bufferHeight: 30.0, defaultDisplayMetrics: BannerDisplayMetrics(0.5, 4, 0.25))
        case .Dog:
            let nib = UINib(nibName: "DogBannerView", bundle: nil)
            let dogBannerView = nib.instantiateWithOwner(nil, options: nil).first as! UIView
            return BannerConfiguration(bannerView: dogBannerView, bufferHeight: 50.0, preferredStatusBarStyle: .LightContent, defaultDisplayMetrics: BannerDisplayMetrics(0.5, 4, 0.25))
        }
    }
}