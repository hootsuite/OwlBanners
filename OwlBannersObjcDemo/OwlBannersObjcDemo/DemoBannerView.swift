//
//  DemoBannerView.swift
//  OwlBannersObjcDemo
//
//  Created by Brett Stover on 2015-12-04.
//  Copyright © 2015 Hootsuite. All rights reserved.
//

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
        let nib = UINib.init(nibName: "DemoBannerView", bundle: nil)
        return nib.instantiateWithOwner(nil, options: nil).first as! DemoBannerView
    }

    class func bannerView(bannerStyle: DemoBannerStyle) -> DemoBannerView {
        let bannerView = DemoBannerView.bannerView()

        switch bannerStyle {
        case .Success:
            bannerView.backgroundColor = .greenColor()
            bannerView.symbolLabel.text = ":)"
        case .Warning:
            bannerView.backgroundColor = .yellowColor()
            bannerView.symbolLabel.text = ":|"
        case .Error:
            bannerView.backgroundColor = .redColor()
            bannerView.symbolLabel.text = ":("
        case .Info:
            bannerView.backgroundColor = .cyanColor()
            bannerView.symbolLabel.text = "!"
        }

        return bannerView
    }


}
