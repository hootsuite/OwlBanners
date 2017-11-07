// Copyright 2017 HootSuite Media Inc.

// This file is part of OwlBanners. The full OwlBanners copyright notice,
// including terms governing use, modification, and redistribution, is
// contained in the file LICENSE.md at the root of the source code distribution
// tree.

import UIKit

/// Protocol that proxies required information for the banner to appear. These properties are present in `UIApplication`
/// but in case when the framework is used within an app extension you will need to provide custom object that conforms
/// to this protocol. See `OwlBannerDemo` app and `OwlBannerShareDemo` app extension for example usage.
@objc public protocol ApplicationContext {

    var keyWindow: UIWindow? { get }
    var statusBarFrame: CGRect { get }
    var preferredContentSizeCategory: UIContentSizeCategory { get }
    var statusBarStyle: UIStatusBarStyle { get set }

}
