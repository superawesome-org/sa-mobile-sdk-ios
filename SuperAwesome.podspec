Pod::Spec.new do |s|
  s.name = 'SuperAwesome'
  s.version = '8.0.0-alpha.2'
  s.summary = 'SuperAwesome Mobile SDK for iOS'
  s.description = <<-DESC
                   The SuperAwesome Mobile SDK lets you to easily add COPPA compliant advertisements and other platform features, like user authentication and registration, to your apps. We try to make integration as easy as possible, so we provide all the necessary tools such as this guide, API documentation, screencasts and demo apps.
                   DESC
  s.homepage = 'https://doc.superawesome.tv/sa-mobile-sdk-ios/latest/'
  s.documentation_url = 'https://doc.superawesome.tv/sa-mobile-sdk-ios/latest/'
  s.license = {
  	:type => 'GNU GENERAL PUBLIC LICENSE Version 3',
  	:file => 'LICENSE'
  }
  s.author = {
     'Gabriel Coman' => 'gabriel.coman@superawesome.com',
     'Gunhan Sancar' => 'gunhan.sancar@superawesome.com'
  }
  
  s.pod_target_xcconfig  = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 arm64e armv7 armv7s',
    'EXCLUDED_ARCHS[sdk=iphoneos*]' => 'i386 x86_64' }
  s.user_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64 arm64e armv7 armv7s',
    'EXCLUDED_ARCHS[sdk=iphoneos*]' => 'i386 x86_64' }
  
  s.ios.deployment_target = '10.0'
  s.swift_versions = ['5.0']
  s.requires_arc = true
  s.source = {
  	:git => 'https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios.git',
  	:branch => 'refactor',
    :tag => "#{s.version}"
  }
  s.static_framework = false
  s.default_subspec = 'Full'

  s.subspec 'Full' do |subspec|
    subspec.dependency 'SuperAwesome/Base'
    subspec.dependency 'SuperAwesome/Moat'

    subspec.test_spec 'Tests' do |test_spec|
      test_spec.source_files = 'Pod/Tests/Common/**/*', 'Pod/Tests/Network/**/*', 'Pod/Tests/Moat/**/*', 'Pod/Tests/UI/**/*'
      test_spec.resources = 'Pod/Tests/Resources/*'
      test_spec.dependency 'Nimble'
      test_spec.dependency 'Mockingjay', '3.0.0-alpha.1'
    end
  end

  s.subspec 'Base' do |subspec|
    subspec.source_files = 'Pod/Sources/Base/**/*'
    subspec.dependency 'SuperAwesome/Common'
    subspec.dependency 'SuperAwesome/UI'
    subspec.dependency 'SuperAwesome/Network'
  end

  s.subspec 'Common' do |subspec|
    subspec.source_files = 'Pod/Sources/Common/**/*'
    subspec.dependency 'SwiftyXMLParser', '~> 5.0'
    subspec.dependency 'SAVideoPlayer', '~> 2.0'
  end

  s.subspec 'Moat' do |subspec|
    subspec.source_files = 'Pod/Sources/Moat/**/*'
    subspec.dependency 'SuperAwesome/Common'
    subspec.vendored_frameworks = 'Pod/Libraries/SUPMoatMobileAppKit.framework'
    subspec.xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) MOAT_MODULE' }
  end

  s.subspec 'UI' do |subspec|
    subspec.source_files = 'Pod/Sources/UI/**/*'
    subspec.dependency 'SuperAwesome/Common'    
  end

  s.subspec 'Network' do |subspec|
    subspec.source_files = 'Pod/Sources/Network/**/*'
    subspec.dependency 'SuperAwesome/Common'
    subspec.dependency 'Moya', '~> 14.0'
  end

  # s.subspec 'MoPub' do |m|
  #   m.dependency 'SuperAwesome/Full'
  #   m.dependency 'mopub-ios-sdk', '~> 5.14'
  #   m.source_files = 'Pod/Plugin/MoPub/*'
  #   m.xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) MOPUB_PLUGIN',
  #                  'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) MOPUB_PLUGIN=1' }
  # end

  # s.subspec 'Unity' do |u|
  #   u.dependency 'SuperAwesome/Full'
  #   u.source_files = 'Pod/Plugin/Unity/*'
  # end
 
end
