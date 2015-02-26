Pod::Spec.new do |s|

  s.name         = "EasyMapping"
  s.version      = "0.12.3"
  s.summary      = "The easiest way to map data from your webservice."
  s.homepage     = "https://github.com/lucasmedeirosleite/EasyMapping"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "Lucas Medeiros" => "lucastoc@gmail.com" }

  s.source       = { :git => "https://github.com/EasyMapping/EasyMapping.git", :tag => s.version.to_s }

  s.requires_arc = true

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'

  s.subspec 'Core' do |core|
    core.frameworks = 'CoreData'
    core.source_files = 'EasyMapping/*.{h,m}'
  end

  s.subspec 'XCTest' do |xctest|
    xctest.dependency 'EasyMapping/Core'
    xctest.frameworks = 'XCTest'
    xctest.source_files = 'XCTest+EasyMapping/*.{h,m}'
  end

  s.default_subspec = 'Core'
end
