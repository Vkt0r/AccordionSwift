#
# Be sure to run `pod lib lint AccordionSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AccordionSwift'
  s.version          = '2.0.2'
  s.summary          = 'An Accordion Menu using an UITableView in Swift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
The best way of implement an accordion menu using an UITableView in Swift
                       DESC

  s.homepage         = 'https://github.com/Vkt0r/AccordionSwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Victor Sigler' => 'vikt0r.sigler@gmail.com' }
  s.source           = { :git => 'https://github.com/Vkt0r/AccordionSwift.git', :tag => "v#{s.version.to_s}" }
  s.social_media_url = 'https://twitter.com/Vkt0r'
  s.swift_version    = '5.0'

  s.ios.deployment_target = '10.0'
  s.source_files = 'Source/*.swift'
end
