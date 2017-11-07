Pod::Spec.new do |s|
  s.name         = "OwlBanners"
  s.version      = "0.4.3"
  s.ios.deployment_target = "10.3"
  s.summary      = "OwlBanners is a simple Swift framework for displaying custom banners."
  s.homepage     = "https://github.com/hootsuite/OwlBanners"
  s.license      = { :type => "Apache", :file => "LICENSE.md" }
  s.author       = { "Hootsuite Media" => "opensource@hootsuite.com" }
  s.platform     = :ios
  s.source       = { :git => "https://github.com/hootsuite/OwlBanners.git", :tag => "v#{s.version}" }
  s.source_files = "Sources/OwlBanners"
  s.resource     = "Resources/OwlBanners/**/*.{xib,xcassets}"
end
