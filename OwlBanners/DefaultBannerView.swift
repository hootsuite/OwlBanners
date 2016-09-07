//  Copyright © 2015 Hootsuite. All rights reserved.

import UIKit

/// Defines banner default styles.
public enum DefaultBannerStyle: BannerStyle {
    case success, warning, error

    public var bannerConfiguration: BannerConfiguration {
        switch self {
        case .success:
            return BannerConfiguration(bannerView: DefaultBannerView.bannerView(.green), bufferHeight: 100.0)
        case .warning:
            return BannerConfiguration(bannerView: DefaultBannerView.bannerView(.yellow), bufferHeight: 100.0)
        case .error:
            return BannerConfiguration(bannerView: DefaultBannerView.bannerView(.red), bufferHeight: 100.0)
        }
    }
}


/// A banner with a default style.
class DefaultBannerView: UIView, BannerView {

    @IBOutlet weak var titleLabel: UILabel!

    var title: String {
        get { return titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }

    class func bannerView() -> DefaultBannerView {
        let bundle = Bundle(for: DefaultBannerView.self)
        let nib = UINib.init(nibName: "DefaultBannerView", bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil).first as! DefaultBannerView
    }

    class func bannerView(_ backgroundColor: UIColor) -> DefaultBannerView {
        let bannerView = DefaultBannerView.bannerView()
        bannerView.backgroundColor = backgroundColor
        return bannerView
    }
}
