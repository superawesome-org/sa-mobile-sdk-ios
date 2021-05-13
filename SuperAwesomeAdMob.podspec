Pod::Spec.new do |s|
  s.name = 'SuperAwesomeAdMob'
  s.version = '8.0.5-admob'
  s.summary = 'SuperAwesome AdMob Adapter for iOS'
  s.description = <<-DESC
  The SuperAwesome Mobile SDK lets you to easily add COPPA compliant advertisements and other platform features, like user authentication and registration, to your apps. We try to make integration as easy as possible, so we provide all the necessary tools such as this guide, API documentation, screencasts and demo apps.
  DESC
  s.homepage = 'https://doc.superawesome.tv/sa-mobile-sdk-ios/latest/'
  s.documentation_url = 'https://doc.superawesome.tv/sa-mobile-sdk-ios/latest/'
  s.license = {
    :type => 'GNU GENERAL PUBLIC LICENSE Version 3',
    :file => 'LICENSE'
  }
  s.author = { 'Gunhan Sancar' => 'gunhan.sancar@superawesome.com' }
  s.source = {
    :git => 'https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios.git',
    :branch => 'master',
    :tag => "7.2.18"
  }

  s.pod_target_xcconfig  = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 arm64e armv7 armv7s',
    'EXCLUDED_ARCHS[sdk=iphoneos*]' => 'i386 x86_64' }
  s.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 arm64e armv7 armv7s',
    'EXCLUDED_ARCHS[sdk=iphoneos*]' => 'i386 x86_64' }

  s.ios.deployment_target = '10.0'
  s.swift_versions = ['4.2', '5.0']
  s.static_framework = true
  s.requires_arc = true

  s.source_files = 'Adapters/AdMob/Classes/**/*'
  s.dependency 'SuperAwesome', '~> 7.2'
  s.dependency 'Google-Mobile-Ads-SDK'
  s.xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) ADMOB_PLUGIN',
                 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) ADMOB_PLUGIN=1' }
end
