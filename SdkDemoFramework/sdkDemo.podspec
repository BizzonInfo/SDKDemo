#
#  Be sure to run `pod spec lint SdkDemo.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = 'SdkDemo'
  s.version      = '3.1.1'
  s.license  = { :type => 'BSD', :text => 'Copyright (C) 2010 Apple Inc. All Rights Reserved.' }
  s.homepage     = 'https://github.com/BizzonInfo/SDKDemo'
  s.authors      = { 'Abiram' => 'jvabiram@gmail.com' }
  s.summary      = 'ARC and GCD Compatible .'
  s.source       = { :git => 'https://github.com/BizzonInfo/SDKDemo.git'}
  s.source_files = "SdkDemoFramework/**/*.{h,m}"
  s.framework    = 'SdkDemo'
  s.platform = :ios
  s.platform = :osx
  s.ios.deployment_target = "5.0"
  s.osx.deployment_target = "10.7"
end
