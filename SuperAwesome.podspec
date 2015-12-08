Pod::Spec.new do |s|
  s.name         = "SuperAwesome"
  s.version      = "3.2.1"
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
  s.source       = { :git => "https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios.git", :tag => "3.2.1" }

  s.dependency "JSONModel", "~> 1.0.2"
  s.frameworks = 'AVFoundation', 'AudioToolbox', 'CFNetwork', 'CoreGraphics', 'CoreData', 'CoreLocation', 'CoreMedia', 'CoreMotion', 'CoreTelephony', 'EventKit', 'MediaPlayer', 'MessageUI', 'MobileCoreServices', 'QuartzCore', 'Security', 'SystemConfiguration', 'StoreKit', 'AdSupport', 'EventKitUI'
  s.libraries = "xml2", "z"
  s.source_files  = "Frameworks/sourcekit-common-ios/src/**/*.{h,m}", "Frameworks/sourcekit-mraid-ios/src/MRAID/**/*.{h,m}", "SuperAwesome/Classes/**/*.{h,m}"
  s.resources = "SuperAwesome/Resources/*"

  s.default_subspec = 'Default'
  
  s.subspec 'Default' do |default|
    default.dependency "GoogleAds-IMA-iOS-SDK", "3.0.beta.12"
  end

  s.subspec 'AdMob' do |admob|
    admob.dependency "GoogleAds-IMA-iOS-SDK-For-AdMob", "3.0.beta.12"
  end
end
