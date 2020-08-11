source 'https://github.com/CocoaPods/Specs.git'
use_frameworks! :linkage => :static
inhibit_all_warnings!
install! 'cocoapods', generate_multiple_pod_projects: true

def shared

#	pod 'ApplicationGroupKit'

	pod 'SnapKit'
	pod 'AutoInch'
#	pod 'MicrosoftFluentUI'
	
end

def layout
    pod 'pop', '~> 1.0'
    pod 'SHFullscreenPopGestureSwift'
    pod 'lottie-ios', '3.1.1'
		pod 'JXSegmentedView'
		pod 'DynamicColor', '~> 4.2.0'
    pod 'MPITextKit'
    pod 'SCLAlertView'
    pod 'SPLarkController'
		pod 'DNSPageView'
end

def lib
    pod 'KeychainAccess'
		pod 'Nuke'
		pod 'FeedKit'
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
  
  pod 'Siren'
  
end

# 广告
def ads
#	pod 'Google-Mobile-Ads-SDK'
#	pod 'mopub-ios-sdk'
	pod 'FBAudienceNetwork'
end

# 性能和崩溃分析
def performance
#	pod 'MLeaksFinder'
	pod 'Bugly'
  
end

target "FunnyFm" do
		platform :ios, '13.0'
	
		ads
		performance
    layout
    lib
    version
    authoration
    network
		shared
end

target "MenuBar" do
	platform :macos, '11'
	
	pod 'Moya'
#	pod 'Kingfisher/SwiftUI'
	pod 'SwiftyJSON'
	pod 'WCDB.swift'
	pod 'FeedKit'
	
end




target "FunnyFmImport" do
	
	platform :ios, '13.0'
	
	shared
	
end

target "FunnyFmShare" do
	
	platform :ios, '13.0'
	
	shared
	
end

