Pod::Spec.new do |s|
  s.name = "SBPickerSelector"
  s.version = "1.2.2"
  s.summary = "Easy framework to setup pickers in your iOS project, easy picker manager."
  s.homepage = "https://github.com/Busta117/SBPickerSelector"
  s.license = { :type => 'MIT', :file => 'LICENSE'}
  s.author = { "Santiago Bustamante" => "busta117@gmail.com" }
  s.source = {
      :git => "https://github.com/Busta117/SBPickerSelector.git",
      :tag => s.version.to_s
    }

  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.source_files = 'SBPickerSelector/Source/*'
  s.resources = 'SBPickerSelector/Resources/*'

end
