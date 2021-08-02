Pod::Spec.new do |s|
  s.name = 'SuperAwesome'
  s.version = '8.0.12-refactor'
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
   'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = {
   'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  
  s.platform = :ios, "11.0"
  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5.4']
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
    subspec.platform = :ios, "11.0"
    subspec.ios.deployment_target = '11.0'
    subspec.xcconfig = { 'IPHONEOS_DEPLOYMENT_TARGET' => '$(inherited)' }

    subspec.test_spec 'Tests' do |test_spec|
      test_spec.source_files = 'Pod/Tests/Common/**/*.{swift}', 'Pod/Tests/Network/**/*.{swift}', 'Pod/Tests/Moat/**/*.{swift}', 'Pod/Tests/UI/**/*.{swift}'
      test_spec.resources = 'Pod/Tests/Resources/*'
      test_spec.dependency 'Nimble'
    end
  end

  s.subspec 'Base' do |subspec|
    subspec.platform = :ios, "11.0"
    subspec.ios.deployment_target = '11.0'
    subspec.source_files = 'Pod/Sources/Base/**/*.{swift}'
    subspec.dependency 'SuperAwesome/Common'
    subspec.dependency 'SuperAwesome/UI'
    subspec.dependency 'SuperAwesome/Network'
    subspec.xcconfig = { 'IPHONEOS_DEPLOYMENT_TARGET' => '$(inherited)' }
  end

  s.subspec 'Common' do |subspec|
    subspec.platform = :ios, "11.0"
    subspec.ios.deployment_target = '11.0'
    subspec.source_files = 'Pod/Sources/Common/**/*.{swift}'
    subspec.xcconfig = { 'IPHONEOS_DEPLOYMENT_TARGET' => '$(inherited)' }
  end

  s.subspec 'Moat' do |subspec|
    subspec.platform = :ios, "11.0"
    subspec.ios.deployment_target = '11.0'
    subspec.source_files = 'Pod/Sources/Moat/**/*.{swift}'
    subspec.dependency 'SuperAwesome/Common'
    subspec.vendored_frameworks = 'Pod/Libraries/SUPMoatMobileAppKit.framework'
    subspec.xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) MOAT_MODULE','IPHONEOS_DEPLOYMENT_TARGET' => '$(inherited)' }
  end

  s.subspec 'UI' do |subspec|
    subspec.platform = :ios, "11.0"
    subspec.ios.deployment_target = '11.0'
    subspec.source_files = 'Pod/Sources/UI/**/*.{swift}'
    subspec.dependency 'SuperAwesome/Common'    
    subspec.xcconfig = { 'IPHONEOS_DEPLOYMENT_TARGET' => '$(inherited)' }
  end

  s.subspec 'Network' do |subspec|
    subspec.platform = :ios, "11.0"
    subspec.ios.deployment_target = '11.0'
    subspec.source_files = 'Pod/Sources/Network/**/*.{swift}'
    subspec.dependency 'SuperAwesome/Common'
    subspec.xcconfig = { 'IPHONEOS_DEPLOYMENT_TARGET' => '$(inherited)' }
  end

  # s.subspec 'MoPub' do |m|
  #   m.dependency 'SuperAwesome/Full'
  #   m.dependency 'mopub-ios-sdk', '~> 5.14'
  #   m.source_files = 'Pod/Plugin/MoPub/*.{swift}'
  #   m.xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) MOPUB_PLUGIN',
  #                  'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) MOPUB_PLUGIN=1' }
  # end

  # s.subspec 'Unity' do |u|
  #   u.dependency 'SuperAwesome/Full'
  #   u.source_files = 'Pod/Plugin/Unity/*'
  # end
 
end
