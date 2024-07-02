# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

# POD_GROUPS
def networking_pod
  pod 'Alamofire'
  pod 'ReachabilitySwift'
  pod 'SDWebImage', '5.14.2'
  pod 'Kingfisher', '~> 5.0'
end
  
def debugging_pod
  pod 'netfox'
  pod 'FLEX'
end
  
def layout_pod
  pod 'SnapKit'
end

def rx_pod
  pod 'RxSwift', '~> 5.1.1'
  pod 'RxCocoa', '~> 5.1.1'
end

def animation_pod
  pod 'lottie-ios'
end

target 'MPProject' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  networking_pod
  debugging_pod
  layout_pod
  rx_pod
  animation_pod

  # Pods for MPProject

  target 'MPProjectTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MPProjectUITests' do
    # Pods for testing
  end

end
