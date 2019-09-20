Pod::Spec.new do |s|
  s.name = 'SuperAwesome'
  s.version = '7.1.1'
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
	'Gabriel Coman' => 'gabriel.coman@superawesome.tv'
  }
  s.ios.deployment_target = '10.0'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '4.2' }
  s.requires_arc = true
  s.source = { 
	:git => 'https://github.com/SuperAwesomeLTD/sa-mobile-sdk-ios.git', 
	:branch => 'master',
	:tag => '7.1.1' 
  }
  s.default_subspec = 'Full'

  s.subspec 'Base' do |b|
    b.source_files = 'Pod/Classes/**/*'
    b.frameworks = 'AdSupport'
    b.dependency 'SAVideoPlayer', '2.0.0-beta7'
    b.dependency 'SAWebPlayer', '1.4.1'
    b.dependency 'SAEvents', '2.2.4'
    b.dependency 'SAAdLoader', '1.4.2'
    b.dependency 'SABumperPage', '1.0.6'
    b.dependency 'SAParentalGate', '1.0.2'
    b.dependency 'SAGDPRKisMinor', '2.0.0'
  end

  s.subspec 'Full' do |f|
    f.dependency 'SuperAwesome/Base'
    f.dependency 'SAEvents/Moat2'
  end
  
#  s.subspec 'AIR' do |a|
#    a.dependency 'SuperAwesome/Base'
#    a.source_files = 'Pod/Plugin/AIR/*'
#  end

  s.subspec 'MoPub' do |m|
    m.dependency 'SuperAwesome/Base'
    m.dependency 'mopub-ios-sdk'
    m.source_files = 'Pod/Plugin/MoPub/*'
  end

#  s.subspec 'AdMob' do |am|
#    am.dependency 'SuperAwesome/Base'
#    am.dependency 'Google-Mobile-Ads-SDK', '7.28.0'
#    am.source_files = 'Pod/Plugin/AdMob/*'
#  end

  s.subspec 'Unity' do |u|
    u.dependency 'SuperAwesome/Base'
    u.source_files = 'Pod/Plugin/Unity/*'
  end
end
