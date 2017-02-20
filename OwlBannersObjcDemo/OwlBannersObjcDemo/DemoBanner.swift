// Copyright 2017 HootSuite Media Inc.
//
// This file is part of OwlBanners. The full OwlBanners copyright notice,
// including terms governing use, modification, and redistribution, is
// contained in the file LICENSE.md at the root of the source code distribution
// tree.

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
