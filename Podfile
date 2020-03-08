source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!
install! 'cocoapods', generate_multiple_pod_projects: true

#keep_dynamically_linked = ['VIResourceLoader', 'GDTResourceLoader']
#
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
		pod 'OfficeUIFabric', '0.2.11'
		pod 'LookinServer', :configurations => ['Debug']
		pod 'DynamicColor', '~> 4.2.0'
		
end

def lib
    pod 'KeychainAccess'
    pod 'WCDB.swift'
		pod 'Nuke', '~> 8.0.1'
		pod 'EFIconFont', :subspecs => ['Complete']
    pod 'SwiftyJSON'
    pod 'Moya'
    pod 'WechatOpenSDK'
		pod 'FeedKit', '~> 8.0'
		pod 'JPush'
		pod 'FirebaseUI/Auth'
		pod 'FirebaseUI/Google'
		pod 'WhatsNewKit'
		pod 'YYKit'
		pod 'AutoInch'
		pod 'Siren'
		pod 'VIMediaCache'
		pod 'Bugly'
    pod 'R.swift'
    pod 'SwiftyStoreKit'
end


# 广告
def ads
#	pod 'Google-Mobile-Ads-SDK'
	pod 'GDTMobSDK', '~> 4.10.5'
end

# 性能和崩溃分析
def performance
	
	pod 'Fabric', '1.10.2'
	pod 'Crashlytics', '3.13.3'
	pod 'Firebase/Analytics'
#  pod 'Firebase/Performance'
	
end


target "FunnyFm" do
		ads
		performance
    layout
    lib
end

