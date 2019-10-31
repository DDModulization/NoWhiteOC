#
#  Be sure to run `pod spec lint NWUtils.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.name         = "NWUtils"
  spec.version      = "0.0.1"
  spec.summary      = "NWUtils."
  spec.description  = <<-DESC-NWUtils
                   DESC
  spec.homepage     = "http://EXAMPLE/NWUtils"
  spec.license      = "MIT (example)"
  spec.author             = { "deepindo" => "732872042@qq.com" }

  spec.source       = { :git => "http://EXAMPLE/NWUtils.git", :tag => "#{spec.version}" }
  spec.source_files  = "NWUtils", "Classes/**/*.{h,m}"
  spec.exclude_files = "NWUtils/Exclude"

  # spec.public_header_files = "NWUtils/**/*.h"
  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"
  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"
  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"
  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"
  # spec.requires_arc = true
  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # spec.dependency "JSONKit", "~> 1.4"

end
