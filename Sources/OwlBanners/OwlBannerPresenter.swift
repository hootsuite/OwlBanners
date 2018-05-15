//  Copyright © 2018 Hootsuite. All rights reserved.

import Foundation

/// Defines a banner presenter
public protocol BannerPresenter {
    func presentBanner(title: String, style: DefaultBannerStyle)
}

/// An `OwlBanner` implementation of a `BannerPresenter`
public final class OwlBannerPresenter: BannerPresenter {

    /// A initializes a `OwlBannerPresenter`
    public init() { }

    public func presentBanner(title: String, style: DefaultBannerStyle) {
        Banner(style, title: title).enqueue()
    }
}
