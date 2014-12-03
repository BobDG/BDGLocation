Pod::Spec.new do |s|
  s.name           = 'BDGLocation'
  s.version        = '0.0.2'
  s.summary        = 'Lightweight wrapper for core location'
  s.license 	   = 'MIT'
  s.description    = 'Lightweight wrapper around corelocation for easy gps updating'
  s.homepage       = 'https://github.com/BobDG/BDGLocation'
  s.authors        = {'Bob de Graaf' => 'graafict@gmail.com'}
  s.source         = { :git => 'https://github.com/BobDG/BDGLocation.git', :tag => '0.0.2' }
  s.source_files   = '*.{h,m}'  
  s.frameworks     = 'CoreLocation'
  s.platform       = :ios
  s.requires_arc   = true
end
