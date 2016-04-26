Pod::Spec.new do |s|
  s.name         = "SuperAwesome"
  s.version      = "3.8.2"
  s.summary      = "SuperAwesome Mobile SDK for iOS"
  s.description  = <<-DESC
                   The SuperAwesome Mobile SDK lets you to easily add COPPA compliant advertisements and other platform features, like user authentication and registration, to your apps. We try to make integration as easy as possible, so we provide all the necessary tools such as this guide, API documentation, screencasts and demo apps.
                   DESC

  s.homepage     = "http://developers.superawesome.tv/docs/iossdk"
  s.documentation_url = 'http://developers.superawesome.tv/docs/iossdk'
  s.license      = { :type => "GNU GENERAL PUBLIC LICENSE Version 3", :file => "LICENSE" }
  s.author             = { "Gabriel Coman" => "gabriel.coman@superawesome.tv" }
  s.platform     = :ios, "6.0"
  s.ios.deployment_target = "6.0"
  s.requires_arc = true
  s.source       = { :git => "https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios.git", :branch => "master" ,:tag => "3.8.2" }

  s.frameworks = 'AdSupport'
  # s.resource_bundles = { 'SuperAwesome' => ['Pod/Assets/*'] }
  s.dependency 'SAUtils'
  s.dependency 'SAVideoPlayer'
  s.dependency 'SAWebPlayer'
  s.dependency 'SAEvents'
  s.dependency 'SAVASTParser'
  s.dependency 'SAJsonParser'
  s.default_subspec = 'Core' 

  s.subspec 'Core' do |c|
    c.source_files = 'Pod/Classes/**/*'
    c.resource_bundles = { 'SuperAwesome' => ['Pod/Assets/*'] }
  end

  s.subspec 'Unity' do |un|
    un.dependency 'SuperAwesome/Core'
    un.source_files = "Pod/Plugin/Unity/*"
    un.pod_target_xcconfig = { 
	'OTHER_LDFLAGS' => '$(inherited)',  
  	'OTHER_CFLAGS' => '$(inherited)',
  	'HEADER_SEARCH_PATHS' => '$(inherited)'
  }
  end

  s.subspec 'MoPub' do |mp|
    mp.dependency 'mopub-ios-sdk'
    mp.dependency 'SuperAwesome/Core'
    mp.source_files = 'Pod/Plugin/MoPub/*'
  end
end
