Pod::Spec.new do |s|
s.name         = "BSAudioManager"
s.version      = "1.0.0"
s.summary      = "豆瓣播放器二次封装."
s.homepage     = "https://github.com/xiaohange/BSAudioManager"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "Hari" => "532167805@qq.com" }
s.platform     = :ios, "8.0"
s.ios.deployment_target = "8.0"
s.source       = { :git => "https://github.com/xiaohange/BSAudioManager.git", :tag => s.version.to_s }
s.social_media_url = 'https://weibo.com/hjq995'
s.requires_arc = true
s.source_files = 'BSAudioManager/BSAudioManager.h'
s.dependency "JQTipView"
s.dependency "JQPhoneNetwork"

s.subspec 'DOUAudioStream' do |ph|
ph.source_files = 'BSAudioManager/DOUAudioStream/**/*'
end

s.subspec 'BSAudioManager' do |ct|
ct.dependency 'BSAudioManager/DOUAudioStream'
ct.source_files = 'BSAudioManager/BSAudioManager/**/*'
end

end

