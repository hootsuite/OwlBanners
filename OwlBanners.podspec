Pod::Spec.new do |s|
  s.name         = "OwlBanners"
  s.version      = "0.1.2"
  s.ios.deployment_target = '8.0'
  s.summary      = "OwlBanners is a simple Swift framework for displaying custom banners."
  s.description  = "OwlBanners is a simple framework for displaying custom banners on iOS."
  s.homepage     = "https://github.hootops.com/iOS/OwlBanners"
  s.license      = { :type => "Apache", :file => "LICENSE.md" }
  s.author       = { 'Brett Stover' => 'iPhone@hootsuite' }
  s.platform     = :ios
  s.source       = { :git => "https://github.hootops.com/iOS/OwlBanners.git", :tag => "0.1.2" }
  s.source_files  = 'OwlBanners'
  s.resource = "OwlBanners/**/*.{png,bundle,xib,nib}"
  s.framework = "XCTest"
  s.requires_arc = true
end
