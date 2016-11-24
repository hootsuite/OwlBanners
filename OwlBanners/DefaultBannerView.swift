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
            let icon = UIImage(named: "ic_banner_complete", in: bundle, compatibleWith: nil)
            view.set(icon: icon, accessibilityLabel: "Success")
        case .warning:
            view.backgroundColor = UIColor(red: 1, green: 0.569, blue: 0, alpha: 1)
            let icon = UIImage(named: "ic_banner_warning", in: bundle, compatibleWith: nil)
            view.set(icon: icon, accessibilityLabel: "Warning")
        case .error:
            view.backgroundColor = UIColor(red: 0.816, green: 0.286, blue: 0.286, alpha: 1)
            let icon = UIImage(named: "ic_banner_error", in: bundle, compatibleWith: nil)
            view.set(icon: icon, accessibilityLabel: "Error")
        case .persistentError:
            view.backgroundColor = UIColor(red: 0.816, green: 0.286, blue: 0.286, alpha: 1)
            let icon = UIImage(named: "ic_banner_error", in: bundle, compatibleWith: nil)
            view.set(icon: icon, accessibilityLabel: "Error")
            requireUserDismissal = true
        case .info:
            view.backgroundColor = UIColor(red: 0.149, green: 0.565, blue: 0.745, alpha: 1)
            let icon = UIImage(named: "ic_banner_info", in: bundle, compatibleWith: nil)
            view.set(icon: icon, accessibilityLabel: "Information")
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

    var title: String {
        get {
            return titleLabel.text ?? ""
        }
        set {
            titleLabel.text = title
        }
    }

    var icon: UIImage? {
        get {
            return iconImageView.image
        }
        set {
            iconImageView.image = newValue
        }
    }

    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var iconImageView: UIImageView!

    class func loadFromNib() -> DefaultBannerView {
        let bundle = Bundle(for: DefaultBannerView.self)
        let nib = UINib(nibName: "DefaultBannerView", bundle: bundle)
        return nib.instantiate(withOwner: nil, options: nil).first as! DefaultBannerView
    }

    func set(icon: UIImage?, accessibilityLabel: String?) {
        iconImageView.image = icon
        iconImageView.accessibilityLabel = accessibilityLabel
    }
}
