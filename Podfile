source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!
install! 'cocoapods', generate_multiple_pod_projects: true

#keep_dynamically_linked = ['GDTMobSDK','VIMediaCache']
#pre_install do |installer|
#  puts "Make pods linked statically except reserved pods"
#  installer.pod_targets.each do |pod|
#    if !keep_dynamically_linked.include?(pod.name)
#      puts "Override the static_framework? method for #{pod.name}"
#      def pod.build_type;
#        Pod::Target::BuildType.static_framework
#      end
#    end
#  end
#end

def layout
    pod 'SnapKit', '~> 4.0.0'
    pod 'pop', '~> 1.0'
    pod 'SHFullscreenPopGestureSwift'
    pod 'lottie-ios', '3.1.1'
		pod 'NVActivityIndicatorView'
		pod 'JXSegmentedView'
		pod 'DynamicColor', '~> 4.2.0'
		pod 'AutoInch'
    pod 'MPITextKit'
    pod 'SCLAlertView'
    pod 'SPLarkController'
		pod 'DNSPageView'
end

def lib
    pod 'KeychainAccess'
		pod 'Nuke', '~> 8.0.1'
		pod 'FeedKit', '~> 8.0'
		pod 'JPush'
    pod 'R.swift'
    pod 'SwiftyStoreKit'
    pod 'WCDB.swift'
end

def network
	
  pod 'ReachabilitySwift'
  pod 'SwiftyJSON'
  pod 'Moya'
  pod 'Tiercel'
  pod 'SwipeCellKit'
  
end

# 授权
def authoration
  
  pod 'FirebaseUI/Auth'
  pod 'FirebaseUI/Google'
  
end

#版本管理
def version
  
  pod 'WhatsNewKit'
  pod 'Siren'
  
end

# 广告
def ads
#	pod 'Google-Mobile-Ads-SDK'
	pod 'GDTMobSDK', '~> 4.10.5'
  
end

# 性能和崩溃分析
def performance
  
	pod 'Bugly'
  
end

target "FunnyFm" do
		ads
		performance
    layout
    lib
    version
    authoration
    network
end

