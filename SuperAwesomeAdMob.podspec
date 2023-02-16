Pod::Spec.new do |s|
  s.name = 'SuperAwesomeAdMob'
  s.version = File.read("Pod/Classes/Common/Model/Version.swift").split(" = ")[1].delete("\"")
  s.summary = 'SuperAwesome AdMob Adapter for iOS'
  s.description = <<-DESC
  The SuperAwesome Mobile SDK lets you to easily add COPPA compliant advertisements and other platform features, like user authentication and registration, to your apps. We try to make integration as easy as possible, so we provide all the necessary tools such as this guide, API documentation, screencasts and demo apps.
  DESC
  s.homepage = 'https://doc.superawesome.tv/sa-mobile-sdk-ios/latest/'
  s.documentation_url = 'https://doc.superawesome.tv/sa-mobile-sdk-ios/latest/'
    s.author = {
     'Gunhan Sancar' => 'gunhan.sancar@superawesome.com',
     'Tom O\'Rourke' => 'tom.orourke@superawesome.com',
     'Myles Eynon' => 'myles.eynon@superawesome.com'
  }
  s.source = {
    :git => 'https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios.git',
    :branch => 'develop',
    :tag => "v#{s.version}"
  }

  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5.0']
  s.static_framework = true
  s.requires_arc = true

  s.source_files = 'Adapters/AdMob/Classes/**/*'
  s.dependency 'SuperAwesome', '~> 8.5'
  s.dependency 'Google-Mobile-Ads-SDK'
  s.xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) ADMOB_PLUGIN',
                 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) ADMOB_PLUGIN=1' }
end
