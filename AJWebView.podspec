Pod::Spec.new do |s|
  s.name             = 'AJWebView'
  s.version          = '0.1.0'
  s.summary          = 'A short description of AJWebView.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/xujiebing/AJWebView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xujiebing' => 'xujiebing@bwton.com' }
  s.source           = { :git => 'https://github.com/xujiebing/AJWebView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AJWebView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AJWebView' => ['AJWebView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
