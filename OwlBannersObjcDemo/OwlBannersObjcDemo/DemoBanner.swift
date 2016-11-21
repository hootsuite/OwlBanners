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
    case success, warning, error, info

    var bannerConfiguration: BannerConfiguration {
        return BannerConfiguration(bannerView: DemoBannerView.bannerView(self), bufferHeight: 100.0, preferredStatusBarStyle: .default, defaultRequiresUserDismissal: false)
    }
}

class DemoBanner: Banner {

    static func successBanner(_ title: String) -> DemoBanner {
        return DemoBanner(DemoBannerStyle.success, title: title)
    }

    static func warningBanner(_ title: String) -> DemoBanner {
        return DemoBanner(DemoBannerStyle.warning, title: title)
    }

    static func errorBanner(_ title: String) -> DemoBanner {
        return DemoBanner(DemoBannerStyle.error, title: title)
    }

    static func infoBanner(_ title: String) -> DemoBanner {
        return DemoBanner(DemoBannerStyle.info, title: title)
    }

}
