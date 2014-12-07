Pod::Spec.new do |s|

  s.name         = "EasyMapping"
  s.version      = "0.8.0"
  s.summary      = "The easiest way to map data from your webservice."
  s.homepage     = "https://github.com/lucasmedeirosleite/EasyMapping"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author       = { "Lucas Medeiros" => "lucastoc@gmail.com" }

  s.source       = { :git => "https://github.com/EasyMapping/EasyMapping.git", :tag => s.version.to_s }

  s.requires_arc = true

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.frameworks = 'CoreData'

  s.source_files = 'EasyMapping/*.{h,m}'

end
