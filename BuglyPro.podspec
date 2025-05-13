Pod::Spec.new do |s|
  s.authors      = "Tencent"
  s.name         = "BuglyPro"
  s.version      = "2.8.0.10"
  s.summary      = "BuglyPro iOS SDK"
  s.description  = "iOS library for Bugly Service. Sign up for a service at https://bugly.tds.qq.com."
  s.homepage     = "http://bugly.tds.qq.com/"
  s.license      = { :type => "Commercial", :text => "Copyright (C) 2025 Tencent Bugly, Inc. All rights reserved."}
  s.author       = { "Tencent" => "bugly@tencent.com" }
  s.source       = { :http => "https://buglyprococoapodssdk-75649.gzc.vod.tencent-cloud.com/BuglyPro-2.8.0.10.zip" }
  s.requires_arc = true  
  s.platform     = :ios
  s.ios.deployment_target = '10.0'
  s.static_framework = true
  s.frameworks = 'SystemConfiguration','Security'
  s.library = 'z','c++'

  s.subspec "Core" do |sp|
    sp.source_files = 'static/BuglyProCore.xcframework/ios-arm64/BuglyProCore.framework/Headers/*.{h}'
    sp.public_header_files = 'static/BuglyProCore.xcframework/ios-arm64/BuglyProCore.framework/Headers/*.{h}'
    sp.vendored_frameworks = 'static/BuglyProCore.xcframework'
    sp.user_target_xcconfig = { 'HEADER_SEARCH_PATHS' => '${PODS_ROOT}/BuglyPro/static/BuglyProCore.xcframework/ios-arm64/BuglyProCore.framework/Headers' }
  end
  
  s.subspec "VCSwizzle" do |sp|
    sp.source_files = 'static/BuglyProVCSwizzle.xcframework/ios-arm64/BuglyProVCSwizzle.framework/Headers/*.{h}'
    sp.public_header_files = 'static/BuglyProVCSwizzle.xcframework/ios-arm64/BuglyProVCSwizzle.framework/Headers/*.{h}'
    sp.vendored_frameworks = 'static/BuglyProVCSwizzle.xcframework'
    sp.dependency "#{s.name}/Core"
  end

  s.subspec "BacktraceRecording" do |sp|
    sp.source_files = 'static/BuglyProBacktraceRecording.xcframework/ios-arm64/BuglyProBacktraceRecording.framework/Headers/*.{h}'
    sp.public_header_files = 'static/BuglyProBacktraceRecording.xcframework/ios-arm64/BuglyProBacktraceRecording.framework/Headers/*.{h}'
    sp.vendored_frameworks = 'static/BuglyProBacktraceRecording.xcframework'
  end

  s.subspec "AppEventTracker" do |sp|
    sp.source_files = 'static/BuglyProAppEventTracker.xcframework/ios-arm64/BuglyProAppEventTracker.framework/Headers/*.{h}'
    sp.public_header_files = 'static/BuglyProAppEventTracker.xcframework/ios-arm64/BuglyProAppEventTracker.framework/Headers/*.{h}'
    sp.vendored_frameworks = 'static/BuglyProAppEventTracker.xcframework'
    sp.dependency "#{s.name}/Core"
    sp.dependency "#{s.name}/VCSwizzle"
  end

  s.subspec "CrashMonitor" do |sp|
    sp.source_files = 'static/BuglyProCrashMonitor.xcframework/ios-arm64/BuglyProCrashMonitor.framework/Headers/*.{h}'
    sp.public_header_files = 'static/BuglyProCrashMonitor.xcframework/ios-arm64/BuglyProCrashMonitor.framework/Headers/*.{h}'
    sp.vendored_frameworks = 'static/BuglyProCrashMonitor.xcframework'
    sp.dependency "#{s.name}/Core"
    sp.dependency "#{s.name}/BacktraceRecording"
    sp.dependency "#{s.name}/AppEventTracker"
    sp.user_target_xcconfig = { 'HEADER_SEARCH_PATHS' => '${PODS_ROOT}/BuglyPro/static/BuglyProCrashMonitor.xcframework/ios-arm64/BuglyProCrashMonitor.framework/Headers' }
  end

  s.subspec "MemoryMonitor" do |sp|
    sp.source_files = [
        'static/BuglyProMemoryMonitor.xcframework/ios-arm64/BuglyProMemoryMonitor.framework/Headers/*.{h}',
        'static/BuglyProYellow.xcframework/ios-arm64/BuglyProYellow.framework/Headers/*.{h}',
    ]
    sp.public_header_files = [
        'static/BuglyProMemoryMonitor.xcframework/ios-arm64/BuglyProMemoryMonitor.framework/Headers/*.{h}',
        'static/BuglyProYellow.xcframework/ios-arm64/BuglyProYellow.framework/Headers/*.{h}',
    ]
    sp.vendored_frameworks = 'static/BuglyProMemoryMonitor.xcframework', 'static/BuglyProYellow.xcframework'
    sp.dependency "#{s.name}/Core"
    sp.dependency "#{s.name}/BacktraceRecording"
    sp.dependency "#{s.name}/AppEventTracker"
  end

  s.subspec "LooperMonitor" do |sp|
    sp.source_files = 'static/BuglyProLooperMonitor.xcframework/ios-arm64/BuglyProLooperMonitor.framework/Headers/*.{h}'
    sp.public_header_files = 'static/BuglyProLooperMonitor.xcframework/ios-arm64/BuglyProLooperMonitor.framework/Headers/*.{h}'
    sp.vendored_frameworks = 'static/BuglyProLooperMonitor.xcframework'
    sp.dependency "#{s.name}/Core"
    sp.dependency "#{s.name}/AppEventTracker"
    sp.user_target_xcconfig = { 'HEADER_SEARCH_PATHS' => '${PODS_ROOT}/BuglyPro/static/BuglyProLooperMonitor.xcframework/ios-arm64/BuglyProLooperMonitor.framework/Headers' }
  end

  s.subspec "LaunchMonitor" do |sp|
    sp.source_files = [
        'static/BuglyProLaunchMonitor.xcframework/ios-arm64/BuglyProLaunchMonitor.framework/Headers/*.{h}',
        'static/BuglyProPageLaunch.xcframework/ios-arm64/BuglyProPageLaunch.framework/Headers/*.{h}',
    ]
    sp.public_header_files = [
        'static/BuglyProLaunchMonitor.xcframework/ios-arm64/BuglyProLaunchMonitor.framework/Headers/*.{h}',
        'static/BuglyProPageLaunch.xcframework/ios-arm64/BuglyProPageLaunch.framework/Headers/*.{h}',
    ]
    sp.vendored_frameworks = 'static/BuglyProLaunchMonitor.xcframework', 'static/BuglyProPageLaunch.xcframework'
    sp.dependency "#{s.name}/Core"
    sp.dependency "#{s.name}/AppEventTracker"
    sp.user_target_xcconfig = { 'HEADER_SEARCH_PATHS' => [
        '${PODS_ROOT}/BuglyPro/static/BuglyProLaunchMonitor.xcframework/ios-arm64/BuglyProLaunchMonitor.framework/Headers',
        '${PODS_ROOT}/BuglyPro/static/BuglyProPageLaunch.xcframework/ios-arm64/BuglyProPageLaunch.framework/Headers',
        ] }
  end

  s.subspec "Network" do |sp|
    sp.source_files = 'static/BuglyProNetwork.xcframework/ios-arm64/BuglyProNetwork.framework/Headers/*.{h}'
    sp.public_header_files = 'static/BuglyProNetwork.xcframework/ios-arm64/BuglyProNetwork.framework/Headers/*.{h}'
    sp.vendored_frameworks = 'static/BuglyProNetwork.xcframework'
    sp.dependency "#{s.name}/Core"
    sp.weak_frameworks = 'Network'
    sp.user_target_xcconfig = { 'HEADER_SEARCH_PATHS' => '${PODS_ROOT}/BuglyPro/static/BuglyProNetwork.xcframework/ios-arm64/BuglyProNetwork.framework/Headers' }
  end

  s.subspec "MetricKitMonitor" do |sp|
    sp.source_files = 'static/BuglyProMetricKitMonitor.xcframework/ios-arm64/BuglyProMetricKitMonitor.framework/Headers/*.{h}'
    sp.public_header_files = 'static/BuglyProMetricKitMonitor.xcframework/ios-arm64/BuglyProMetricKitMonitor.framework/Headers/*.{h}'
    sp.vendored_frameworks = 'static/BuglyProMetricKitMonitor.xcframework'
    sp.dependency "#{s.name}/Core"
    sp.weak_frameworks = 'MetricKit'
    sp.user_target_xcconfig = { 'HEADER_SEARCH_PATHS' => '${PODS_ROOT}/BuglyPro/static/BuglyProMetricKitMonitor.xcframework/ios-arm64/BuglyProMetricKitMonitor.framework/Headers' }
    end

  s.subspec "BuglyGWPASan" do |sp|
    sp.source_files = 'static/BuglyGWPASan.xcframework/ios-arm64/BuglyGWPASan.framework/Headers/*.{h}'
    sp.public_header_files = 'static/BuglyGWPASan.xcframework/ios-arm64/BuglyGWPASan.framework/Headers/*.{h}'
    sp.vendored_frameworks = 'static/BuglyGWPASan.xcframework'
    sp.dependency "#{s.name}/Core"
  end

  s.subspec "BuglyPro" do |sp|
    sp.source_files = 'static/BuglyPro.xcframework/ios-arm64/BuglyPro.framework/Headers/*.{h}'
    sp.public_header_files = 'static/BuglyPro.xcframework/ios-arm64/BuglyPro.framework/Headers/*.{h}'
    sp.vendored_frameworks = 'static/BuglyPro.xcframework'
    sp.weak_frameworks = 'Network', 'MetricKit'
  end

  s.subspec "BuglyProOAExtension" do |sp|
    sp.source_files = 'static/BuglyProOAExtension.xcframework/ios-arm64/BuglyProOAExtension.framework/Headers/*.{h}'
    sp.public_header_files = 'static/BuglyProOAExtension.xcframework/ios-arm64/BuglyProOAExtension.framework/Headers/*.{h}'
    sp.vendored_frameworks = 'static/BuglyProOAExtension.xcframework'
    sp.weak_frameworks = 'Network', 'MetricKit'
  end

  s.default_subspec = "BuglyPro"

  s.pod_target_xcconfig = {'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }

end
