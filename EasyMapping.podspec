Pod::Spec.new do |s|
  s.name         = "EasyMapping"
  s.version      = "0.20.1"
  s.summary      = "The easiest way to map data from your webservice."
  s.homepage     = "https://github.com/lucasmedeirosleite/EasyMapping"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors       = { "Lucas Medeiros"  => "lucastoc@gmail.com",
                      "Denys Telezhkin" => "denys.telezhkin@yandex.ru" }
  s.source       = { :git => "https://github.com/lucasmedeirosleite/EasyMapping.git", :tag => s.version.to_s }
  s.requires_arc = true

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'

  s.subspec 'Core' do |core|
    core.watchos.deployment_target = '2.0'
    core.ios.deployment_target = '8.0'
    core.osx.deployment_target = '10.9'
    core.tvos.deployment_target = '9.0'
    core.frameworks = 'CoreData'
    core.source_files = 'Sources/EasyMapping/*.{h,m}'
  end

  s.subspec 'XCTest' do |xctest|
    xctest.ios.deployment_target = '8.0'
    xctest.osx.deployment_target = '10.9'
    xctest.tvos.deployment_target = '9.0'
    xctest.dependency 'EasyMapping/Core'
    xctest.frameworks = 'XCTest'
    xctest.xcconfig = { 'FRAMEWORK_SEARCH_PATHS' => '$(PLATFORM_DIR)/Developer/Library/Frameworks' }
    xctest.source_files = 'Sources/EasyMapping+XCTestCase/*.{h,m}'
  end

  s.default_subspec = 'Core'
end
