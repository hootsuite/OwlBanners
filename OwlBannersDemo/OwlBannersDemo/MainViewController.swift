// Copyright 2017 HootSuite Media Inc.

// This file is part of OwlBanners. The full OwlBanners copyright notice,
// including terms governing use, modification, and redistribution, is
// contained in the file LICENSE.md at the root of the source code distribution
// tree.

import UIKit
import OwlBanners

class MainViewController: UIViewController {

    @IBAction func showSuccessBanner(_ sender: AnyObject) {
        Banner(DefaultBannerStyle.success, title: "Great job you did it.").enqueue()
    }

    @IBAction func showAnotherSuccessBanner(_ sender: AnyObject) {
        Banner(DefaultBannerStyle.success, title: "Wooooooooooooooooooooooooooooooh.").enqueue()
    }

    @IBAction func showWarningBanner(_ sender: AnyObject) {
        Banner(DefaultBannerStyle.warning, title: "Oops something went wrong. :S").enqueue()
    }

    @IBAction func showErrorBanner(_ sender: AnyObject) {
        Banner(DefaultBannerStyle.error, title: "#epicfail").enqueue()
    }

    @IBAction func showCustomBanner(_ sender: AnyObject) {
        Banner(AnimalBannerStyle.cat).enqueue()
    }

    @IBAction func showAnotherCustomBanner(_ sender: AnyObject) {
        Banner(AnimalBannerStyle.dog, title: "WOOF!").enqueue()
    }

    @IBAction func showSuccessBannerWithCustomTiming(_ sender: AnyObject) {
        let banner = Banner(DefaultBannerStyle.success, title: "Slooooooow but good.")
        banner.displayMetrics = BannerDisplayMetrics(2, 4, 2)
        banner.enqueue()
    }

    @IBAction func showSuccessBannerRequiresUserDismissal(_ sender: AnyObject) {
        let banner = Banner(DefaultBannerStyle.success, title: "I'm not going away until you tap or swipe up on me!!!")
        banner.requiresUserDismissal = true
        banner.enqueue()
    }

    @IBAction func showSuccessBannerWithUserDismissAction(_ sender: AnyObject) {
        let banner = Banner(DefaultBannerStyle.success, title: "Tap me for an alert!")
        banner.userDismissalAction = {
            let alertController = UIAlertController(title: "The user made an action.", message: "Thanks user!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "You're welcome.", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
        banner.enqueue()
    }

    @IBAction func presentTestViewController(_ sender: AnyObject) {
        let testViewController = TestViewController()
        present(testViewController, animated: true, completion: nil)
    }
}
