//  Copyright © 2015 Hootsuite. All rights reserved.

import UIKit

/// Defines banner default styles.
public enum DefaultBannerStyle: BannerStyle {
    case success
    case warning
    case error
    case persistentError
    case info

    public var bannerConfiguration: BannerConfiguration {
        let bundle = Bundle(for: DefaultBannerView.self)
        let view = DefaultBannerView.loadFromNib()
        var requireUserDismissal = false

        switch self {
        case .success:
            view.backgroundColor = UIColor(red: 0.424, green: 0.647, blue: 0.117, alpha: 1)
            view.icon = UIImage(named: "ic_banner_complete", in: bundle, compatibleWith: nil)
        case .warning:
            view.backgroundColor = UIColor(red: 1, green: 0.569, blue: 0, alpha: 1)
            view.icon = UIImage(named: "ic_banner_warning", in: bundle, compatibleWith: nil)
        case .error:
            view.backgroundColor = UIColor(red: 0.816, green: 0.286, blue: 0.286, alpha: 1)
            view.icon = UIImage(named: "ic_banner_error", in: bundle, compatibleWith: nil)
        case .persistentError:
            view.backgroundColor = UIColor(red: 0.816, green: 0.286, blue: 0.286, alpha: 1)
            view.icon = UIImage(named: "ic_banner_error", in: bundle, compatibleWith: nil)
            requireUserDismissal = true
        case .info:
            view.backgroundColor = UIColor(red: 0.149, green: 0.565, blue: 0.745, alpha: 1)
            view.icon = UIImage(named: "ic_banner_info", in: bundle, compatibleWith: nil)
        }

        return BannerConfiguration(
            bannerView: view,
            bufferHeight: 100,
            preferredStatusBarStyle: .lightContent,
            defaultRequiresUserDismissal: requireUserDismissal)
    }
}

/// A banner with a default style.
class DefaultBannerView: UIView, BannerView {

    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }

    var icon: UIImage? {
        didSet {
            iconImageView.image = icon
        }
    }

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var iconImageView: UIImageView!

    class func loadFromNib() -> DefaultBannerView {
        let bundle = Bundle(for: DefaultBannerView.self)
        let nib = UINib(nibName: "DefaultBannerView", bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil).first as! DefaultBannerView
    }
}
