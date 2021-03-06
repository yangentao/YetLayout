#
# Be sure to run `pod lib lint YetLayout.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YetLayout'
  s.version          = '1.0.0'
  s.summary          = 'iOS Auto Layout by Swift'
  s.description      = <<-DESC
        iOS Auto Layout by Swift, Easy to Use.
                       DESC

  s.homepage         = 'https://github.com/yangentao/YetLayout'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yangentao' => 'entaoyang@163.com' }
  s.source           = { :git => 'https://github.com/yangentao/YetLayout.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'YetLayout/Classes/**/*'
  
  # s.resource_bundles = {
  #   'YetLayout' => ['YetLayout/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'

  s.frameworks = 'UIKit'
end
