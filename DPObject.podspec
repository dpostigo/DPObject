Pod::Spec.new do |s|
  s.name         = "DPObject"
  s.version      = "0.0.2"
  s.summary      = "In development."
  s.homepage     = "http://dpostigo.com"
  s.license      = 'BSD'
  s.author       = { "Dani Postigo" => "dani@firstperson.is" }
  s.source       = { :git => "https://github.com/dpostigo/DPObject.git", :tag => s.version.to_s }
  s.platform     = :osx, '10.8'
  s.source_files = 'DPObject/*.{h,m}'
  s.frameworks   = 'QuartzCore'
  s.requires_arc = true

  s.dependency   'DPKit'
  # s.dependency   'NSView-DPAutolayout', :git => '/Users/danipostigo/Development/LocalPods/NSView-DPAutolayout'
  # s.dependency   'NSView-DPAutolayout', :local => '~/Development/LocalPods/NSView-DPAutolayout'
  # s.dependency 'NSView-DPAutolayout', :path =>' /Users/danipostigo/Development/LocalPods/NSView-DPAutolayout/NSView-DPAutolayout.podspec'
end
