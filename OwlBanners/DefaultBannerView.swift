//
//  GenericBannerView.swift
//  BannerPrototype
//
//  Created by Brett Stover on 2015-09-23.
//  Copyright © 2015 Hootsuite. All rights reserved.
//

import UIKit


public enum DefaultBannerStyle: BannerStyle {
    case Success, Warning, Error
    
    public var bannerConfiguration: BannerConfiguration {
        switch (self) {
        case .Success:
            return BannerConfiguration(bannerView: DefaultBannerView.bannerView(.greenColor()), bufferHeight: 100.0)
        case .Warning:
            return BannerConfiguration(bannerView: DefaultBannerView.bannerView(.yellowColor()), bufferHeight: 100.0)
        case .Error:
            return BannerConfiguration(bannerView: DefaultBannerView.bannerView(.redColor()), bufferHeight: 100.0)
        }
    }
}


class DefaultBannerView: UIView, BannerView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var title: String {
        get { return titleLabel.text ?? "" }
        set { titleLabel.text = newValue }
    }
    
    class func bannerView() -> DefaultBannerView {
        let bundle = NSBundle(forClass: DefaultBannerView.self)
        let nib = UINib.init(nibName: "DefaultBannerView", bundle: bundle)
        return nib.instantiateWithOwner(nil, options: nil).first as! DefaultBannerView
    }
    
    class func bannerView(backgroundColor: UIColor) -> DefaultBannerView {
        let bannerView = DefaultBannerView.bannerView()
        bannerView.backgroundColor = backgroundColor
        return bannerView
    }
}
