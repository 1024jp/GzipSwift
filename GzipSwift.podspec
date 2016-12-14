Pod::Spec.new do |s|
  s.name          = "GzipSwift"
  s.version       = "3.1.3"
  s.summary       = "Swift framework that enables gzip/gunzip Data using zlib."

  s.homepage      = "https://github.com/1024jp/GzipSwift"
  s.license       = { :type => "MIT",
                      :file => "LICENSE" }
  s.author        = { "1024jp" => "1024jp@wolfrosch.com" }
  s.social_media_url = "https://twitter.com/1024jp"

  s.source        = { :git => "https://github.com/1024jp/GzipSwift.git",
                      :tag => s.version }
  s.source_files  = 'Sources/*.swift'
  
  s.module_name = 'Gzip'
  s.osx.deployment_target     = '10.9'
  s.ios.deployment_target     = '8.0'
  s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target    = '9.0'
  
  s.requires_arc  = true
  s.library       = 'z'
  s.preserve_path = 'zlib/*'
  s.pod_target_xcconfig = { 'SWIFT_INCLUDE_PATHS' => '$(PODS_ROOT)/GzipSwift/zlib' }
end
