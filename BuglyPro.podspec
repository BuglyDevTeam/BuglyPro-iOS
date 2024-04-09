Pod::Spec.new do |s|
  s.authors      = "Tencent"
  s.name         = "BuglyPro"
  s.version      = "2.7.53.5"
  s.summary      = "BuglyPro iOS SDK"
  s.description  = "iOS library for Bugly Service. Sign up for a service at https://bugly.tds.qq.com."
  s.homepage     = "http://bugly.tds.qq.com/"
  s.license      = { :type => "Commercial", :text => "Copyright (C) 2024 Tencent Bugly, Inc. All rights reserved."}
  s.author       = { "Tencent" => "bugly@tencent.com" }
  s.source       = { :http => "https://buglyprococoapodssdk-75649.gzc.vod.tencent-cloud.com/BuglyPro-2.7.53.5.zip" }
  s.requires_arc = true  
  s.platform     = :ios
  s.ios.deployment_target = '9.0'
  s.vendored_frameworks ='BuglyPro.xcframework'
  s.frameworks = 'SystemConfiguration','Security','Network'
  s.library = 'z','c++'
  s.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
      Copyright (C) 2024 Tencent Bugly, Inc. All rights reserved.
      LICENSE
  }
  end
