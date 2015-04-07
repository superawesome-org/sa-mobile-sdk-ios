Pod::Spec.new do |s|
  s.name         = "SuperAwesome"
  s.version      = "1.2.0"
  s.summary      = "SuperAwesome Mobile SDK for iOS"

  s.description  = <<-DESC
                   The SuperAwesome Mobile SDK lets you to easily add COPPA compliant advertisements and other platform features, like user authentication and registration, to your apps. We try to make integration as easy as possible, so we provide all the necessary tools such as this guide, API documentation, screencasts and demo apps.
                   DESC

  s.homepage     = "http://developers.superawesome.tv/docs/iossdk"
  s.documentation_url = 'http://developers.superawesome.tv/docs/iossdk'
  s.license      = { :type => "CREATIVE COMMONS PUBLIC LICENSE", :file => "LICENSE.txt" }
  s.author             = { "Balazs Kiss" => "balazs@superawesome.tv" }

  s.platform     = :ios, "6.0"
  s.ios.deployment_target = "6.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios", :tag => "1.2.0" }

  s.source_files  = "SuperAwesome"
  s.resources = "SuperAwesome/Resources/*"

  s.vendored_frameworks = 'Frameworks/ADTECHMobileSDK.framework'
  s.frameworks = 'AVFoundation', 'AudioToolbox', 'CFNetwork', 'CoreGraphics', 'CoreData', 'CoreLocation', 'CoreMedia', 'CoreMotion', 'CoreTelephony', 'EventKit', 'MediaPlayer', 'MessageUI', 'MobileCoreServices', 'QuartzCore', 'Security', 'SystemConfiguration', 'StoreKit', 'AdSupport', 'EventKitUI'
  s.libraries = "xml2", "z"
  s.dependency "JSONModel", "~> 1.0.2"
  s.dependency "GoogleAds-IMA-iOS-SDK", "~> 3.0.beta.11"

end