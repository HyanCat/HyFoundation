
Pod::Spec.new do |s|
  s.name             = "HyFoundation"
  s.version          = "0.1.0"
  s.summary          = "A Foundation Library."
  s.license          = { :type => 'MIT', :file => 'LICENSE' }

  s.description      = <<-DESC
  A Foundation Library.
                       DESC

  s.homepage         = "https://github.com/HyanCat/HyFoundation"
  s.license          = 'MIT'
  s.author           = { "HyanCat" => "hyancat@live.cn" }
  s.source           = { :git => "https://github.com/HyanCat/HyFoundation.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.dependency  'DateTools'
  s.dependency  'Masonry'

  s.source_files = 'HyFoundation/**/*.{h,m}'
  s.public_header_files = 'HyFoundation/**/*.h'
  s.resource = 'HyFoundation/**/*.xib'

end
