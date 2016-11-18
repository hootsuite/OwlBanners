Pod::Spec.new do |s|
  s.name         = "OwlBanners"
  s.version      = "0.2.0"
  s.ios.deployment_target = "8.0"
  s.summary      = "OwlBanners is a simple Swift framework for displaying custom banners."
  s.homepage     = "https://github.com/hootsuite/OwlBanners"
  s.license      = { :type => "Apache", :file => "LICENSE.md" }
  s.author       = { "Hootsuite Media" => "opensource@hootsuite.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/hootsuite/OwlBanners.git", :tag => "v#{s.version}" }
  s.source_files = "OwlBanners"
  s.resource     = "OwlBanners/**/*.{png,bundle,xib,nib}"
  s.weak_framework = "XCTest"
  s.requires_arc = true
end
