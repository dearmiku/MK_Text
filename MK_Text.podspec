Pod::Spec.new do |s|
  s.name             = 'MK_Text'
  s.version          = '0.1.0'
  s.summary          = '帮助开发者处理富文本的Swift框架'
 
  s.description      = <<-DESC
    帮助开发者处理富文本的Swift框架,具体内容后续补充 详情看主页~(๑•ᴗ•๑)
                       DESC
 

  s.homepage         = 'https://github.com/dearmiku/MK_Text.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dear_Miku' => '372154465@qq.com' }
  s.source           = { :git => 'https://github.com/dearmiku/MK_Text.git', :tag => s.version.to_s }
 

  s.osx.deployment_target = "10.10"
  s.ios.deployment_target = "8.0"

  s.source_files = 'MK_Text/Source/*.swift'

  s.swift_version    = '4.0' 

 
end