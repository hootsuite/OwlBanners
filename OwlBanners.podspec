Pod::Spec.new do |s|
  s.name         = 'OwlBanners'
  s.version      = '0.5.1'
  s.summary      = 'OwlBanners is a simple Swift framework for displaying custom banners.'
  s.homepage     = "https://github.com/hootsuite/OwlBanners"
  s.license      = { :type => "Apache", :file => "LICENSE.md" }
  s.author       = { "Hootsuite Media" => "opensource@hootsuite.com" }

  s.platform     = :ios, '11.0'
  s.source       = { :git => "https://github.com/hootsuite/OwlBanners.git", :tag => "v#{s.version}" }
  s.source_files = "Sources/OwlBanners"
  s.resource     = "Sources/OwlBanners/Resources/**/*.{xib,xcassets}"
end
