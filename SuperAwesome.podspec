Pod::Spec.new do |s|
  s.name = 'SuperAwesome'
  s.version = File.read("Pod/Classes/Common/Model/Version.swift").split(" = ")[1].delete("\"")
  s.summary = 'SuperAwesome Mobile SDK for iOS'
  s.description = <<-DESC
                   The SuperAwesome Mobile SDK lets you to easily add COPPA compliant advertisements and other platform features, like user authentication and registration, to your apps. We try to make integration as easy as possible, so we provide all the necessary tools such as this guide, API documentation, screencasts and demo apps.
                   DESC
  s.homepage = 'https://doc.superawesome.tv/sa-mobile-sdk-ios/latest/'
  s.documentation_url = 'https://doc.superawesome.tv/sa-mobile-sdk-ios/latest/'
  s.author = {
     'Gabriel Coman' => 'gabriel.coman@superawesome.com',
     'Gunhan Sancar' => 'gunhan.sancar@superawesome.com',
     'Tom O\'Rourke' => 'tom.orourke@superawesome.com',
     'Myles Eynon' => 'myles.eynon@superawesome.com'
  }
  
  s.ios.deployment_target = '10.0'
  s.swift_versions = ['5.0']
  s.requires_arc = true
  s.source = {
  	:git => 'https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios.git',
  	:branch => 'develop',
  	:tag => "v#{s.version}"
  }
  s.static_framework = false

  s.dependency 'SwiftyXMLParser', '5.6.0'
  s.dependency 'Moya', '~> 14.0'
  s.source_files = 'Pod/Classes/**/*'

# s.subspec 'Unity' do |u|
#    u.dependency 'SuperAwesome/Full'
#    u.source_files = 'Pod/Plugin/Unity/*'
# end
 
end
