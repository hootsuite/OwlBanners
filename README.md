# OwlBanners
[![GitHub license](https://img.shields.io/badge/license-Apache%202-lightgrey.svg)](https://raw.githubusercontent.com/Carthage/Carthage/master/LICENSE.md)
[![GitHub release](https://img.shields.io/github/release/carthage/carthage.svg)](https://github.com/Carthage/Carthage/releases)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/Alamofire.svg)](https://img.shields.io/cocoapods/v/Alamofire.svg)

OwlBanners is a simple Swift framework for displaying custom banners.

OwlBanners has been developed for use in the Hootsuite iOS app.

## Features

- Use provided default banners or supply custom views for use as banners.
- Automatic queueing of banners (i.e., banners will display one-at-a-time even when triggered all-at-once).
- Coalescion of sequential duplicate banners (e.g., if four of the same banner with the same title get called rapidly only one will be displayed).
- Correct handling of status bar changes and rotation while banners are displayed.
- Completion actions for when the banner dismisses or when the user force dismisses the banner.
- Custom timing of banner display.

## Ideas for Future Development

- Add the ability to change the type of animation to display and dismiss the banner.
- Configure the location where banner appears, currently only appears on the top of the screen.

## Requirements

- iOS 10.3+
- Xcode 8.3+

## Demo Projects

See the two demo projects provided (OwlBannersDemo and OwlBannersObjcDemo) for example usage of the OwlBanners framework.

## Installation

OwlBanners can be installed using either [Carthage](https://github.com/Carthage/Carthage) or [CocoaPods](https://cocoapods.org/).

### Carthage

To integrate OwlBanners into your Xcode project using Carthage, specify it in your Cartfile:

```swift
github "hootsuite/OwlBanners"
```

### CocoaPods

First, add the following line to your Podfile:

```swift
pod 'OwlBanners'
```

Second, install OwlBanners into your project:

```
pod install
```

## Initialization

OwlBanners requires access to the currently displayed `UIWindow` as well as some additional information about the app's UI. All these requirements are stated in a protocol named `ApplicationContext`.
A very convenient way to hook up all these requirements is to simply make your `UIApplication` conform to `ApplicationContext` since it already provides everything necessary for `ApplicationContext`.
```swift
extension UIApplication: ApplicationContext {}
```
Once that is done you can initialize OwlBanners in your `AppDelegate`:
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    // Your setup code here

    Banner.application = UIApplication.shared
}
```
## Usage

OwlBanners provides several default banners and allows for the addition of custom banners. Banners are backed by UIView objects which conform to the BannerView protocol and are grouped by "banner styles" represented as structs conforming to the BannerStyle protocol.

A default banner style is provided which allows for displaying simple success, warning, error and info banners.

### Creating and Displaying a Default Banner

Banners are easily created by supplying a banner style and a title to the Banner intializer. For example, we can create the default success banner as follows:

```swift
let banner = Banner(DefaultBannerStyle.Success, title: "My first banner!")
```

Displaying a banner is as simple as calling the enqueue() method on a banner object.

```swift
banner.enqueue()
```

This will display our banner as so:

![My first banner](https://cloud.githubusercontent.com/assets/5861750/15160900/c1233640-16b0-11e6-8fba-61d2c2149371.gif)

When multiple banners are enqueued, banners will display in order, one-at-a-time, coalescing duplicates.

### Creating a Custom Banner

To create a custom banner you must provide a UIView that implements the BannerView protocol, a struct that implements the BannerStyle protocol and a BannerConfiguration for each case within the banner style struct.

#### BannerView

The BannerView protocol is defined as:

```swift
public protocol BannerView {
    var title: String { get set }
}
```

See DogBannerView.swift in the OwlBannersDemo project for an example implementation of a custom banner view.

Note that if your banner does not display a textual title, you do not strictly need to implement the BannerView protocol. However, without implementing it, coalescing of duplicate banners will not occur. For this reason, it may be desirable to implement BannerView even if the textual title is not displayed on the banner.

#### BannerStyle

The BannerStyle protocol is defined as:

```swift
public protocol BannerStyle {
    var bannerConfiguration: BannerConfiguration { get }
}
```

To setup a banner style, you create a struct with as many cases as desired and then switch on these cases when returning a BannerConfiguration object. See AnimalBannerStyle.swift in the OwlBannersDemo project for an example implementation.

#### BannerConfiguration

The BannerConfiguration initializer takes two mandatory and three optional parameters. These include the view implementing BannerView, a bufferHeight (discussed in the next session), the preferred status bar style, the default display metrics to be used, and the default setting for requiring user dismissal.

```swift
BannerConfiguration(bannerView: DefaultBannerView.bannerView(.greenColor()), bufferHeight: 100.0)
```

When the preferred status bar style is set on the configuration, the status bar style will be switched to the preferred stylye while the banner is displayed and then will be reset to its original style when the banner is dismissed. This requires "View controller-based status bar appearance" to be set to NO in your app's Info.plist file.

```
<key>UIViewControllerBasedStatusBarAppearance</key>
	<false/>
```

The default display metrics define the timing of the banners with a given configuration unless otherwise overriden directly on the Banner object. The display metrics struct defines presentation, display and dismissal durations. If not supplied, the banner will use sensible defaults.

For example, if BannerDisplayMetrics(1.0, 2.0, 3.0) was supplied as display metrics to the configuration returned for a .Success case on a banner style called MyStyle, then all banners created with Banner(MyStyle.Success, title: "My title") would take 1 second to present, 2 to display on screen, and 3 to dismiss. If desired, this could then be overridden a per banner case using:

```swift
let slowBanner = Banner(MyStyle.Success, title: "Slow")
slowBanner.displayMetrics = BannerDisplayMetrics(5, 5, 5)
```

The default requires user dismissal parameter defines if the banners for a given case within a style require user dismissal. If not supplied, this defaults to false. Again, if set, this can be overriden on a per case basis using:

```swift
let banner = Banner(MyStyle.Success, title: "Dismiss me!")
banner.requiresUserDismissal = true
```

#### Designing Your Custom Banner's View

As seen in the last section, the BannerConfiguration object makes use of a bufferHeight parameter. When designing your banner's view you should think in terms of there being a buffer zone at the top of the view, followed by a content zone.

This buffer zone serves two important purposes:

1. The status bar may change size during your app's usage (e.g., due to an incoming call). The buffer zone is partially displayed behind the status bar and allows for your content to always display below the status bar (i.e., the buffer zone prevents your banner's content from being covered up by the status bar).
2. When the banner drops down, it will drop slightly past it's destination point and then bounce back to the correct position. This is part of the spring animation used for displaying banners. Without a buffer zone, an unsightly gap would be shown above the banner during this animation.

The bufferHeight parameter supplied to the BannerConfiguration is the height of this buffer zone. The actual content of the banner should not be displayed in the buffer zone. The buffer zone will be displayed under the status bar and will extend partially off screen for the reasons given above.

In practice, a buffer zone of 100px or greater should suffice, but you should test the display of banners while with the device is stationary, with an incoming call, and during rotation to ensure the buffer zone is large enough as the height of your banner and the supplied display metrics may affect the height of buffer needed.

See DogBannerView.swift and AnimalBannerStyle.swift in the OwlBannersDemo project for an example of buffer usage.

#### Displaying a Custom Banner

Displaying a custom banner works the same as displaying a default banner. Banner's of any banner style can be intermixed as appropriate and will display as part of the same queue.

```swift
Banner(CustomBannerStyle.Success, title: "My first custom success banner!").enqueue()
Banner(DefaultBannerStyle.Success, title: "Another default success banner!").enqueue()
Banner(CustomBannerStyle.Success, title: "Another custom success banner!").enqueue()

```

### Objective-C

OwlBanners makes use of Swift features such as Swift-style enums and enum protocols which are not supported by Objective-C. Due to this, the framework cannot be used in Objective-C only projects, but can be used in mixed Objective-C and Swift projects.

This is done by writing the banner customization code in Swift and then providing a wrapper that can be accessed via Objective-C.

This wrapper may look something like:

```swift    
class DemoBanner: Banner {
    static func successBanner(title: String) -> DemoBanner {
        return DemoBanner(DemoBannerStyle.Success, title: title)
    }
}
```

The Objective-C code would then access the banners as:

```
[[DemoBanner successBanner:@"Success banner"] enqueue];

```

See the OwlBannersObjcDemo demo project for a more detailed example.

## License

OwlBanners is released under the Apache License, Version 2.0. See [LICENSE.md](LICENSE.md) for details.
