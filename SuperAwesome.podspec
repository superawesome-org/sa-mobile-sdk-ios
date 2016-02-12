Pod::Spec.new do |s|
  s.name         = "SuperAwesome"
  s.version      = "3.4.8"
  s.summary      = "SuperAwesome Mobile SDK for iOS"

  s.description  = <<-DESC
                   The SuperAwesome Mobile SDK lets you to easily add COPPA compliant advertisements and other platform features, like user authentication and registration, to your apps. We try to make integration as easy as possible, so we provide all the necessary tools such as this guide, API documentation, screencasts and demo apps.
                   DESC

  s.homepage     = "http://developers.superawesome.tv/docs/iossdk"
  s.documentation_url = 'http://developers.superawesome.tv/docs/iossdk'
  s.license      = { :type => "CREATIVE COMMONS PUBLIC LICENSE", :file => "LICENSE.txt" }
  s.author             = { "Gabriel Coman" => "gabriel.coman@superawesome.tv" }

  s.platform     = :ios, "6.0"
  s.ios.deployment_target = "6.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios.git", :branch => "master" ,:tag => "3.4.7" }

  s.frameworks = 'AVFoundation', 'AudioToolbox', 'CFNetwork', 'CoreGraphics', 'CoreData', 'CoreLocation', 'CoreMedia', 'CoreMotion', 'CoreTelephony', 'EventKit', 'MediaPlayer', 'MessageUI', 'MobileCoreServices', 'QuartzCore', 'Security', 'SystemConfiguration', 'StoreKit', 'AdSupport', 'EventKitUI'
  s.libraries = "xml2", "z"
  s.source_files  = "SuperAwesome/Classes/**/*.{h,m}"
  s.resources = "SuperAwesome/Resources/*"
end
