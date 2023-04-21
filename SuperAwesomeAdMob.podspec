Pod::Spec.new do |s|
  s.name = 'SuperAwesomeAdMob'
  s.version = File.read("SuperAwesome/Classes/Common/Model/Version.swift").split(" = ")[1].delete("\"")
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
  s.readme = "https://aa-sdk.s3.eu-west-1.amazonaws.com/ios_repo/SuperAwesome/#{s.version}/SuperAwesome-#{s.version}-README.md"
  s.source = {
    :http => "https://aa-sdk.s3.eu-west-1.amazonaws.com/ios_repo/SuperAwesomeAdMob/#{s.version}/SuperAwesomeAdMob-#{s.version}.zip"
  }

  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5.0']
  s.static_framework = true
  s.requires_arc = true

  s.source_files = 'SuperAwesomeAdMob/Classes/**/*'
  s.dependency 'SuperAwesome', "~> #{s.version}"
  s.dependency 'Google-Mobile-Ads-SDK'
  s.xcconfig = { 'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => '$(inherited) ADMOB_PLUGIN',
                 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) ADMOB_PLUGIN=1' }
end
