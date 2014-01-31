Pod::Spec.new do |s|
  s.name         = "DPObject"
  s.version      = "0.0.1"
  s.summary      = "Basic objects."
  s.homepage     = "http://dpostigo.com"
  s.license      = 'BSD'
  s.author       = { "Dani Postigo" => "dani@firstperson.is" }
  s.source       = { :git => "https://github.com/dpostigo/DPObject.git", :tag => s.version.to_s }

  s.requires_arc = true

  s.source_files = 'DPObject/*.{h,m}'


  s.ios.deployment_target = '4.3'
  s.osx.deployment_target = '10.8'

  s.dependency   'DPKit'

  s.frameworks   = 'QuartzCore'
  
  # s.dependency   'NSView-DPAutolayout', :git => '/Users/danipostigo/Development/LocalPods/NSView-DPAutolayout'
  # s.dependency   'NSView-DPAutolayout', :local => '~/Development/LocalPods/NSView-DPAutolayout'
  # s.dependency 'NSView-DPAutolayout', :path =>' /Users/danipostigo/Development/LocalPods/NSView-DPAutolayout/NSView-DPAutolayout.podspec'
end
