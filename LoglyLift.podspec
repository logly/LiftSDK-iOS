#
# Be sure to run `pod lib lint LoglyLift.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = "LoglyLift"
    s.version          = "0.9.1"

    s.summary          = "Logly lift.json API"
    s.description      = <<-DESC
                         Logly lift.json API for Lift Mobile SDK
                         DESC

    s.platform     = :ios, '7.0'
    s.requires_arc = true

    s.framework    = 'SystemConfiguration'

    s.homepage     = "https://github.com/logly/LiftSDK-iOS"
    s.license      = "Apache License, Version 2.0"
    s.source       = { :git => "https://github.com/logly/LiftSDK-iOS.git", :tag => "#{s.version}" }
    s.author       = { "Logly co.ltd" => "info@logly.co.jp" }

    s.source_files = 'LoglyLift/**/*.{m,h}'
    s.public_header_files = 'LoglyLift/**/*.h'


    s.dependency 'AFNetworking', '~> 3'
    s.dependency 'JSONModel', '~> 1.2'
    s.dependency 'ISO8601', '~> 0.5'
end

