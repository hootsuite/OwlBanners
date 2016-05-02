//
//  Banner.swift
//  BannerPrototype
//
//  Created by Brett Stover on 9/22/15.
//  Copyright © 2015 Hootsuite. All rights reserved.
//


import UIKit


public protocol BannerStyle {
    var bannerConfiguration: BannerConfiguration { get }
}


public protocol BannerView {
    var title: String { get set }
}


public struct BannerConfiguration {
    private let bannerView: UIView
    private let bufferHeight: CGFloat
    private let preferredStatusBarStyle: UIStatusBarStyle?
    private let defaultDisplayMetrics: BannerDisplayMetrics?
    private let defaultRequiresUserDismissal: Bool?
    
    public init(bannerView: UIView, bufferHeight: CGFloat, preferredStatusBarStyle: UIStatusBarStyle? = nil, defaultDisplayMetrics: BannerDisplayMetrics? = nil, defaultRequiresUserDismissal: Bool? = nil) {
        self.bannerView = bannerView
        self.bufferHeight = bufferHeight
        self.preferredStatusBarStyle = preferredStatusBarStyle
        self.defaultDisplayMetrics = defaultDisplayMetrics
        self.defaultRequiresUserDismissal = defaultRequiresUserDismissal
    }
}


public struct BannerDisplayMetrics {
    private var presentDuration, displayDuration, dismissDuration: NSTimeInterval
    
    public init(_ presentDuration: NSTimeInterval, _ displayDuration :NSTimeInterval, _ dismissDuration: NSTimeInterval) {
        self.presentDuration = presentDuration
        self.displayDuration = displayDuration
        self.dismissDuration = dismissDuration
    }
}


public class Banner: NSObject {
    
    // Constants
    
    private struct Constants {
        static let presentAnimationDamping: CGFloat = 0.3
        static let presentAnimationVelocity: CGFloat = 0.7
        static let dismissAnimationDamping: CGFloat = 1.0
        static let dismissAnimationVelocity: CGFloat = 0.7
    }
    
    // Static Properties
    
    private static let displayBeginSemaphore = dispatch_semaphore_create(1)
    private static let displayEndSemaphore = dispatch_semaphore_create(0)
    private static let displayQueue: NSOperationQueue = {
        let displayQueue = NSOperationQueue()
        displayQueue.maxConcurrentOperationCount = 1
        return displayQueue
    }()
    
    // MARK: Public Properties
    
    public var displayMetrics = BannerDisplayMetrics(0.5, 2.0, 0.25)
    public var userDismissalAction: (() -> Void)?
    public var completionAction:(() -> Void)?
    public var requiresUserDismissal = false
    
    // MARK: Private Properties
    
    private let style: BannerStyle
    private let title: String
    
    private let bannerView: UIView
    private var currentStatusBarStyle: UIStatusBarStyle = .Default
    private var isDismissing = false
    private var dupeKey: String {
        return "\(style.dynamicType).\(style): \(title)"
    }
    
    private var keyWindow: UIWindow {
        let keyWindow = UIApplication.sharedApplication().keyWindow
        assert(keyWindow != nil, "Attempted to display banner without a key window. Hint: Ensure enqueue is called after the view loads.")
        return keyWindow!
    }
    
    private var topConstraint: NSLayoutConstraint? = nil
    
    private var heightOfVisiblePortionOfBanner: CGFloat {
        return bannerView.frame.size.height - style.bannerConfiguration.bufferHeight
    }
    
    private var topConstraintConstantWhenHidden: CGFloat {
        return -(heightOfVisiblePortionOfBanner + style.bannerConfiguration.bufferHeight)
    }
    
    private var topConstraintConstantWhenDisplayed: CGFloat {
        return -style.bannerConfiguration.bufferHeight + UIApplication.sharedApplication().statusBarFrame.size.height
    }
    
    // MARK: Initalizers
    
    public convenience init(_ style: BannerStyle) {
        self.init(style, title: "")
    }

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
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Banner.deviceOrientationDidChange(_:)), name: UIDeviceOrientationDidChangeNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(Banner.applicationWillChangeStatusBarFrame(_:)), name: UIApplicationWillChangeStatusBarFrameNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
    }
    
    // MARK: Public Functions
    
    public func enqueue() {
        if bannerIsDuplicateOfLastItemInDisplayQueue() == false {
            let operation = NSBlockOperation(block: {
                dispatch_semaphore_wait(Banner.displayBeginSemaphore, DISPATCH_TIME_FOREVER)
                dispatch_async(dispatch_get_main_queue(), {
                    self.setup()
                    self.present()
                })
                dispatch_semaphore_wait(Banner.displayEndSemaphore, DISPATCH_TIME_FOREVER)
            })
            
            operation.name = dupeKey
            
            Banner.displayQueue.addOperation(operation)
        }
    }
    
    // MARK: Private Functions
    
    private func setup() {
        keyWindow.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("|[bannerView]|", options: [], metrics: nil, views: ["bannerView":bannerView])
        let heightConstraint = NSLayoutConstraint(item: bannerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: bannerView.frame.size.height)
        topConstraint = NSLayoutConstraint(item: bannerView, attribute: .Top, relatedBy: .Equal, toItem: keyWindow, attribute: .Top, multiplier: 1.0, constant: topConstraintConstantWhenHidden)
        NSLayoutConstraint.activateConstraints(horizontalConstraints + [heightConstraint, topConstraint!])
        
        if var bannerView = bannerView as? BannerView {
            bannerView.title = title
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(Banner.bannerDismissed(_:)))
        bannerView.addGestureRecognizer(tapRecognizer)
        bannerView.userInteractionEnabled = true
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(Banner.bannerDismissed(_:)))
        swipeRecognizer.direction = .Up
        bannerView.addGestureRecognizer(swipeRecognizer)
    }
    
    private func present() {
        bannerView.layoutIfNeeded()
        
        currentStatusBarStyle = UIApplication.sharedApplication().statusBarStyle
        if let statusBarStyle = style.bannerConfiguration.preferredStatusBarStyle {
            UIApplication.sharedApplication().statusBarStyle = statusBarStyle
        }
        
        UIView.animateWithDuration(displayMetrics.presentDuration, delay: 0, usingSpringWithDamping: Constants.presentAnimationDamping,
            initialSpringVelocity: Constants.presentAnimationVelocity,
            options: [.AllowUserInteraction, .CurveEaseIn], animations: {
                if (self.isDismissing == false) {
                    self.topConstraint?.constant = self.topConstraintConstantWhenDisplayed
                    self.bannerView.layoutIfNeeded()
                }
            }, completion: { _ in
                if (self.isDismissing == false) {
                    self.topConstraint?.constant = self.topConstraintConstantWhenDisplayed
                    
                    if self.requiresUserDismissal == false {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(self.displayMetrics.displayDuration * NSTimeInterval(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                            self.dismiss()
                        }
                    }
                }
        })
    }
    
    private func dismiss() {
        bannerView.layoutIfNeeded()
        
        if isDismissing == false {
            isDismissing = true
            UIApplication.sharedApplication().statusBarStyle = currentStatusBarStyle
            
            UIView.animateWithDuration(displayMetrics.dismissDuration, delay: 0, usingSpringWithDamping: Constants.dismissAnimationDamping,
                initialSpringVelocity: Constants.dismissAnimationVelocity,
                options: [.BeginFromCurrentState, .CurveEaseIn], animations: {
                    self.topConstraint?.constant = self.topConstraintConstantWhenHidden
                    self.bannerView.layoutIfNeeded()
                }, completion: { _ in
                    self.completionAction?()
                    self.bannerView.removeFromSuperview()
                    dispatch_semaphore_signal(Banner.displayBeginSemaphore)
                    dispatch_semaphore_signal(Banner.displayEndSemaphore)
            })
        }
    }
    
    private func bannerIsDuplicateOfLastItemInDisplayQueue() -> Bool {
        if let lastOperation = Banner.displayQueue.operations.last where lastOperation.name == dupeKey {
            return true
        }
        
        return false
    }
    
    // MARK: User Actions
    
    @objc private func bannerDismissed(sender: AnyObject?) {
        CATransaction.begin()
        bannerView.layer.removeAllAnimations()
        CATransaction.commit()
        userDismissalAction?()
        dismiss()
    }
    
    // MARK: Notification Callbacks
    
    @objc private func deviceOrientationDidChange(notif: NSNotification) {
        if isDismissing == false {
            topConstraint?.constant = topConstraintConstantWhenDisplayed
        }
    }
    
    @objc private func applicationWillChangeStatusBarFrame(notif: NSNotification) {
        if isDismissing == false {
            topConstraint?.constant = topConstraintConstantWhenDisplayed
        }
    }
}
