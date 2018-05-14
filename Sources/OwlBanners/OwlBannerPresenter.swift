//  Copyright © 2018 Hootsuite. All rights reserved.

import Foundation

/// Defines a banner presenter
public protocol BannerPresenter {
    func presentErrorBanner(title: String, style: DefaultBannerStyle)
}

/// An `OwlBanner` implementation of a `BannerPresenter`
public final class OwlBannerPresenter: BannerPresenter {
    public func presentErrorBanner(title: String, style: DefaultBannerStyle) {
        Banner(style, title: title).enqueue()
    }
}
