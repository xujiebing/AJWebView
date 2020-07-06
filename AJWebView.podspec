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

  s.ios.deployment_target = '9.0'

  s.source_files = 'AJWebView/Classes/**/*.{h,m}'
  s.resource_bundles = {
    'AJWebView' => ['AJWebView/Assets/Image.xcassets']
  }
  s.prefix_header_file = 'AJWebView/Classes/AJWebView.pch'
  s.dependency 'AJKit', '0.4.2'
#  s.dependency 'BWTBaseAbility/Location'
#  s.dependency 'BWTBaseAbility/Share'
#  s.dependency 'BWTBaseAbility/InvalidApplePay'
#  s.dependency 'BWTCommonAbility'
#  s.dependency 'BWTCommonAbility/Scan'
#  s.dependency 'BWTPedometer'
  
end
