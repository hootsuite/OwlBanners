//  Copyright © 2015 Hootsuite. All rights reserved.

import UIKit
import OwlBanners

class MainViewController: UIViewController {

    @IBAction func showSuccessBanner(sender: AnyObject) {
        Banner(DefaultBannerStyle.Success, title: "Great job you did it.").enqueue()
    }

    @IBAction func showAnotherSuccessBanner(sender: AnyObject) {
        Banner(DefaultBannerStyle.Success, title: "Wooooooooooooooooooooooooooooooh.").enqueue()
    }

    @IBAction func showWarningBanner(sender: AnyObject) {
        Banner(DefaultBannerStyle.Warning, title: "Oops something went wrong. :S").enqueue()
    }

    @IBAction func showErrorBanner(sender: AnyObject) {
        Banner(DefaultBannerStyle.Error, title: "#epicfail").enqueue()
    }

    @IBAction func showCustomBanner(sender: AnyObject) {
        Banner(AnimalBannerStyle.Cat).enqueue()
    }

    @IBAction func showAnotherCustomBanner(sender: AnyObject) {
        Banner(AnimalBannerStyle.Dog, title: "WOOF!").enqueue()
    }

    @IBAction func showSuccessBannerWithCustomTiming(sender: AnyObject) {
        let banner = Banner(DefaultBannerStyle.Success, title:"Slooooooow but good.")
        banner.displayMetrics = BannerDisplayMetrics(2, 4, 2)
        banner.enqueue()
    }

    @IBAction func showSuccessBannerRequiresUserDismissal(sender: AnyObject) {
        let banner = Banner(DefaultBannerStyle.Success, title: "I'm not going away until you tap or swipe up on me!!!")
        banner.requiresUserDismissal = true
        banner.enqueue()
    }

    @IBAction func showSuccessBannerWithUserDismissAction(sender: AnyObject) {
        let banner = Banner(DefaultBannerStyle.Success, title: "Tap me for an alert!")
        banner.userDismissalAction = {
            let alertController = UIAlertController(title: "The user made an action.", message: "Thanks user!", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "You're welcome.", style: .Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        banner.enqueue()
    }

    @IBAction func presentTestViewController(sender: AnyObject) {
        let testViewController = TestViewController()
        presentViewController(testViewController, animated: true, completion: nil)
    }
}
