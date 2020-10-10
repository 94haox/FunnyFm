source 'https://github.com/CocoaPods/Specs.git'
use_frameworks! :linkage => :static
inhibit_all_warnings!
install! 'cocoapods', generate_multiple_pod_projects: true

def ios_shared
	pod 'SnapKit'
	pod 'AutoInch'
	pod ''
end

def apple_shared
  
  pod 'FeedKit'
  pod 'WCDB.swift'
  pod 'Moya'
  pod 'SwiftyJSON'
  
end

def layout
    pod 'pop'
    pod 'SHFullscreenPopGestureSwift'
    pod 'lottie-ios'
    pod 'JXSegmentedView'
    pod 'AutoInch'
    pod 'SCLAlertView'
		pod 'DNSPageView'
    pod 'BSText'
		pod 'SwipeCellKit'
end

def lib
    pod 'KeychainAccess'
		pod 'Nuke'
		pod 'JPush'
    pod 'R.swift'
    pod 'SwiftyStoreKit'
    pod 'ReachabilitySwift'
end

def network
  pod 'Tiercel'
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
#	pod 'FBAudienceNetwork'
end

# 性能和崩溃分析
def performance
#	pod 'MLeaksFinder'
	pod 'Bugly'
  
end

target "FunnyFm" do
		platform :ios, '14.0'
	
		ads
		performance
    layout
    lib
    version
    authoration
    network
		ios_shared
    apple_shared
end

target "NowExtension" do
	platform :ios, '14.0'
	pod 'Nuke'
end

target "MenuBar" do
  
	platform :macos, '11'
  
  apple_shared
  
end

#target "Clips" do
#  
#  platform :ios, '14'
#  
#  pod 'FeedKit'
#  pod 'Moya'
#  pod 'SwiftyJSON'
#end



target "FunnyFmImport" do
	
	platform :ios, '14.0'
	
	ios_shared
	
end

target "FunnyFmShare" do
	
	platform :ios, '14.0'
	
	ios_shared
	
end

