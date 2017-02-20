// Copyright 2017 HootSuite Media Inc.
//
// This file is part of OwlBanners. The full OwlBanners copyright notice,
// including terms governing use, modification, and redistribution, is
// contained in the file LICENSE.md at the root of the source code distribution
// tree.

import UIKit

/// Defines a banner's style.
public protocol BannerStyle {
    /// The presentation parameters.
    var bannerConfiguration: BannerConfiguration { get }
}

/// Things that have a title.
public protocol BannerView {
    /// The banner's display title.
    var title: String { get set }
}

/// Banner presentation parameters.
public struct BannerConfiguration {
    fileprivate let bannerView: UIView
    fileprivate let bufferHeight: CGFloat
    fileprivate let preferredStatusBarStyle: UIStatusBarStyle?
    fileprivate let defaultDisplayMetrics: BannerDisplayMetrics?
    fileprivate let defaultRequiresUserDismissal: Bool?

    /// Creates a `BannerConfiguration`.
    public init(bannerView: UIView, bufferHeight: CGFloat, preferredStatusBarStyle: UIStatusBarStyle? = nil, defaultDisplayMetrics: BannerDisplayMetrics? = nil, defaultRequiresUserDismissal: Bool? = nil) {
        self.bannerView = bannerView
        self.bufferHeight = bufferHeight
        self.preferredStatusBarStyle = preferredStatusBarStyle
        self.defaultDisplayMetrics = defaultDisplayMetrics
        self.defaultRequiresUserDismissal = defaultRequiresUserDismissal
    }
}

/// Banner timing parameters.
public struct BannerDisplayMetrics {
    fileprivate var presentDuration, displayDuration, dismissDuration: TimeInterval

    /// Creates an instance of `BannerDisplayMetrics`.
    public init(_ presentDuration: TimeInterval, _ displayDuration: TimeInterval, _ dismissDuration: TimeInterval) {
        self.presentDuration = presentDuration
        self.displayDuration = displayDuration
        self.dismissDuration = dismissDuration
    }
}

/// Banner model object.
open class Banner: NSObject {

    // Constants

    fileprivate struct Constants {
        static let presentAnimationDamping: CGFloat = 0.3
        static let presentAnimationVelocity: CGFloat = 0.7
        static let dismissAnimationDamping: CGFloat = 1.0
        static let dismissAnimationVelocity: CGFloat = 0.7
    }

    // Static Properties

    fileprivate static let displayBeginSemaphore = DispatchSemaphore(value: 1)
    fileprivate static let displayEndSemaphore = DispatchSemaphore(value: 0)
    fileprivate static let displayQueue: OperationQueue = {
        let displayQueue = OperationQueue()
        displayQueue.maxConcurrentOperationCount = 1
        return displayQueue
    }()

    // MARK: Public Properties

    /// The banner's timing parameters.
    open var displayMetrics = BannerDisplayMetrics(0.5, 2.0, 0.25)

    /// The action to invoke when the banner is dismissed.
    open var userDismissalAction: (() -> Void)?

    /// The action to invoke when the banner times out.
    open var completionAction:(() -> Void)?

    /// Determines whether the banner requires the user to dismiss it.
    open var requiresUserDismissal = false

    // MARK: Private Properties

    fileprivate let style: BannerStyle
    fileprivate let title: String

    fileprivate let bannerView: UIView
    fileprivate var currentStatusBarStyle: UIStatusBarStyle = .default
    fileprivate var isDismissing = false
    fileprivate var dupeKey: String {
        return "\(type(of: style)).\(style): \(title)"
    }

    fileprivate var keyWindow: UIWindow {
        let keyWindow = UIApplication.shared.keyWindow
        assert(keyWindow != nil, "Attempted to display banner without a key window. Hint: Ensure enqueue is called after the view loads.")
        return keyWindow!
    }

    fileprivate var topConstraint: NSLayoutConstraint?

    fileprivate var topConstraintConstantWhenHidden: CGFloat {
        return -(bannerView.frame.size.height + style.bannerConfiguration.bufferHeight)
    }

    fileprivate var topConstraintConstantWhenDisplayed: CGFloat {
        return -style.bannerConfiguration.bufferHeight + UIApplication.shared.statusBarFrame.size.height
    }

    // MARK: Initializers

    /// Creates a banner with the given style.
    public convenience init(_ style: BannerStyle) {
        self.init(style, title: "")
    }

    /// Creates a banner with the given style a title.
    public init(_ style: BannerStyle, title: String) {
        self.style = style
        self.title = title
        self.bannerView = style.bannerConfiguration.bannerView
        if let displayMetrics = style.bannerConfiguration.defaultDisplayMetrics {
            self.displayMetrics = displayMetrics
        }
        if let requiresUserDismissal = style.bannerConfiguration.defaultRequiresUserDismissal {
            self.requiresUserDismissal = requiresUserDismissal
        }
        super.init()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(Banner.deviceOrientationDidChange(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(Banner.applicationWillChangeStatusBarFrame(_:)), name: NSNotification.Name.UIApplicationWillChangeStatusBarFrame, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
    }

    // MARK: Public Functions

    /// Adds `self` to the queue of banners to display.
    open func enqueue() {
        if !bannerIsDuplicateOfLastItemInDisplayQueue() {
            let operation = BlockOperation(block: {
                let _ = Banner.displayBeginSemaphore.wait(timeout: DispatchTime.distantFuture)
                DispatchQueue.main.async(execute: {
                    self.setup()
                    self.present()
                })
                let _ = Banner.displayEndSemaphore.wait(timeout: DispatchTime.distantFuture)
            })

            operation.name = dupeKey

            Banner.displayQueue.addOperation(operation)
        }
    }

    // MARK: Private Functions

    fileprivate func setup() {
        keyWindow.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false

        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "|[bannerView]|", options: [], metrics: nil, views: ["bannerView": bannerView])
        topConstraint = NSLayoutConstraint(item: bannerView, attribute: .top, relatedBy: .equal, toItem: keyWindow, attribute: .top, multiplier: 1.0, constant: topConstraintConstantWhenHidden)
        NSLayoutConstraint.activate(horizontalConstraints + [topConstraint!])

        if var bannerView = bannerView as? BannerView {
            bannerView.title = title
        }

        // add height constraint
        bannerView.superview?.layoutIfNeeded()
        let height = bannerView.frame.size.height + style.bannerConfiguration.bufferHeight
        let heightConstraint = NSLayoutConstraint(item: bannerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        NSLayoutConstraint.activate([heightConstraint])

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(Banner.bannerDismissed(_:)))
        bannerView.addGestureRecognizer(tapRecognizer)
        bannerView.isUserInteractionEnabled = true

        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(Banner.bannerDismissed(_:)))
        swipeRecognizer.direction = .up
        bannerView.addGestureRecognizer(swipeRecognizer)
    }

    fileprivate func present() {
        bannerView.superview?.layoutIfNeeded()

        currentStatusBarStyle = UIApplication.shared.statusBarStyle
        if let statusBarStyle = style.bannerConfiguration.preferredStatusBarStyle {
            UIApplication.shared.statusBarStyle = statusBarStyle
        }

        UIView.animate(withDuration: displayMetrics.presentDuration, delay: 0, usingSpringWithDamping: Constants.presentAnimationDamping,
            initialSpringVelocity: Constants.presentAnimationVelocity,
            options: [.allowUserInteraction, .curveEaseIn], animations: {
                if self.isDismissing {
                    return
                }
                self.topConstraint?.constant = self.topConstraintConstantWhenDisplayed
                self.bannerView.superview?.layoutIfNeeded()
            }, completion: { _ in
                if self.isDismissing {
                    return
                }
                self.topConstraint?.constant = self.topConstraintConstantWhenDisplayed

                if !self.requiresUserDismissal {
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(self.displayMetrics.displayDuration * TimeInterval(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
                        self.dismiss()
                    }
                }
        })
    }

    fileprivate func dismiss() {
        bannerView.superview?.layoutIfNeeded()

        if isDismissing {
            return
        }
        isDismissing = true
        UIApplication.shared.statusBarStyle = currentStatusBarStyle

        UIView.animate(withDuration: displayMetrics.dismissDuration, delay: 0, usingSpringWithDamping: Constants.dismissAnimationDamping,
            initialSpringVelocity: Constants.dismissAnimationVelocity,
            options: [.beginFromCurrentState, .curveEaseIn], animations: {
                self.topConstraint?.constant = self.topConstraintConstantWhenHidden
                self.bannerView.superview?.layoutIfNeeded()
            }, completion: { _ in
                self.completionAction?()
                self.bannerView.removeFromSuperview()
                Banner.displayBeginSemaphore.signal()
                Banner.displayEndSemaphore.signal()
        })
    }

    fileprivate func bannerIsDuplicateOfLastItemInDisplayQueue() -> Bool {
        if let lastOperation = Banner.displayQueue.operations.last, lastOperation.name == dupeKey {
            return true
        }

        return false
    }

    // MARK: User Actions

    @objc fileprivate func bannerDismissed(_ sender: AnyObject?) {
        CATransaction.begin()
        bannerView.layer.removeAllAnimations()
        CATransaction.commit()
        userDismissalAction?()
        dismiss()
    }

    // MARK: Notification Callbacks

    @objc fileprivate func deviceOrientationDidChange(_ notif: Notification) {
        if !isDismissing {
            topConstraint?.constant = topConstraintConstantWhenDisplayed
        }
    }

    @objc fileprivate func applicationWillChangeStatusBarFrame(_ notif: Notification) {
        if !isDismissing {
            topConstraint?.constant = topConstraintConstantWhenDisplayed
        }
    }
}
