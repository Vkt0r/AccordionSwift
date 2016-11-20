#
# Be sure to run `pod lib lint AccordionMenuSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AccordionMenuSwift'
  s.version          = '1.2.5'
  s.summary          = 'An Accordion Menu using an UITableView in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
The best way of implement an accordion menu using an UITableView in Swift
                       DESC

  s.homepage         = 'https://github.com/Vkt0r/AccordionMenuSwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Victor Sigler' => 'vikt0r.sigler@gmail.com' }
  s.source           = { :git => 'https://github.com/Vkt0r/AccordionMenuSwift.git', :tag => "v.#{s.version.to_s}" }
  s.social_media_url = 'https://twitter.com/Vkt0r'

  s.ios.deployment_target = '8.0'

  s.source_files = 'AccordionMenuSwift/Classes/**/*'

  # s.resource_bundles = {
  #   'AccordionMenuSwift' => ['AccordionMenuSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
