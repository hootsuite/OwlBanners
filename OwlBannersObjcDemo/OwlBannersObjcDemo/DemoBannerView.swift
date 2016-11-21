//  Copyright © 2015 Hootsuite. All rights reserved.

import Foundation
import UIKit
import OwlBanners

class DemoBannerView: UIView, BannerView {

    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!

    var title: String {
        get { return titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }

    class func bannerView() -> DemoBannerView {
        let nib = UINib(nibName: "DemoBannerView", bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! DemoBannerView
    }

    class func bannerView(_ bannerStyle: DemoBannerStyle) -> DemoBannerView {
        let bannerView = DemoBannerView.bannerView()

        switch bannerStyle {
        case .success:
            bannerView.backgroundColor = .green
            bannerView.symbolLabel.text = ":)"
        case .warning:
            bannerView.backgroundColor = .yellow
            bannerView.symbolLabel.text = ":|"
        case .error:
            bannerView.backgroundColor = .red
            bannerView.symbolLabel.text = ":("
        case .info:
            bannerView.backgroundColor = .cyan
            bannerView.symbolLabel.text = "!"
        }

        return bannerView
    }

}
