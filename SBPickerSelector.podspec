Pod::Spec.new do |s|
  s.name = "SBPickerSelector"
  s.version = "1.1.0"
  s.summary = "Easy framework to setup pickers in your iOS project, easy picker manager."
  s.homepage = "https://github.com/Busta117/SBPickerSelector"
  s.license = { :type => 'MIT', :file => 'LICENSE'}
  s.author = { "Santiago Bustamante" => "busta117@gmail.com" }
  s.source = {
      :git => "https://github.com/Busta117/SBPickerSelector.git",
      :tag => s.version.to_s
    }
        
  s.ios.deployment_target = '6.0'
    
  s.default_subspec = 'Core'
  s.requires_arc = true
  
  s.subspec 'Core' do |c|
    c.source_files = 'SBPickerSelector/Source/*'
    c.resources = 'SBPickerSelector/Resources/*'
  end
  
end