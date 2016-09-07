//
//  DemoBanner.swift
//  OwlBannersObjcDemo
//
//  Created by Brett Stover on 2015-12-04.
//  Copyright © 2015 Hootsuite. All rights reserved.
//

import Foundation
import OwlBanners

enum DemoBannerStyle: BannerStyle {
    case Success, Warning, Error, Info

    var bannerConfiguration: BannerConfiguration {
        return BannerConfiguration(bannerView: DemoBannerView.bannerView(self), bufferHeight: 100.0, preferredStatusBarStyle: .Default, defaultRequiresUserDismissal: false)
    }
}

class DemoBanner: Banner {

    static func successBanner(title: String) -> DemoBanner {
        return DemoBanner(DemoBannerStyle.Success, title: title)
    }

    static func warningBanner(title: String) -> DemoBanner {
        return DemoBanner(DemoBannerStyle.Warning, title: title)
    }

    static func errorBanner(title: String) -> DemoBanner {
        return DemoBanner(DemoBannerStyle.Error, title: title)
    }

    static func infoBanner(title: String) -> DemoBanner {
        return DemoBanner(DemoBannerStyle.Info, title: title)
    }

}
