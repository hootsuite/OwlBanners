//
//  ShareViewController.swift
//  OwlBannersShareDemo
//
//  Created by Artem Goryaev on 2017-03-14.
//  Copyright © 2017 Hootsuite. All rights reserved.
//

import UIKit
import Social
import OwlBanners

class ShareViewController: SLComposeServiceViewController {

    override func presentationAnimationDidFinish() {
        Banner.application = self
        Banner(DefaultBannerStyle.success, title: "Great job you did it.").enqueue()
    }

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.

        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}


extension ShareViewController: ApplicationContext {

    // Since app extension doesn't have access to status bar style we provide default implementaion to satisfy the
    // protocol requirement
    public var statusBarStyle: UIStatusBarStyle {
        get { return .default }
        set(newValue) {}
    }

    var keyWindow: UIWindow? {
        return view.window
    }

    // Since app extension doesn't have access to status bar frame we provide default frame to satisfy the
    // protocol requirement
    var statusBarFrame: CGRect {
        return CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20.0)
    }

    var preferredContentSizeCategory: UIContentSizeCategory {
        return view.traitCollection.preferredContentSizeCategory
    }

}
