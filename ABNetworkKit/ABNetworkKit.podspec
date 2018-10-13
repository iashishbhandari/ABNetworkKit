Pod::Spec.new do |s|
s.name    = 'ABNetworkKit'
s.version = '0.1.0'
s.summary = 'A protocol oriented approach to HTTP Networking on iOS'
s.homepage = 'https://github.com/iashishbhandari'
s.license  = 'MIT'
s.author = { 'Ashish Bhandari' => 'ashishbhandariplus@gmail.com' }
s.platform = :ios
s.source = { :git => 'https://github.com/iashishbhandari/ABNetworkKit.git', :tag => '0.1.0'}

s.swift_version = '4.2'
s.ios.deployment_target = '9.0'

s.source_files = 'Source/*.swift'
s.source_files = 'Source/Protocols/*.swift'

s.framework = 'Foundation'
end
