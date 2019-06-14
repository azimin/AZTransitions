Pod::Spec.new do |s|
  s.name         = "AZTransitions"
  s.version      = "0.24"
  s.summary      = "Framework that helps you to work with custom modal transtions."
  s.description  = <<-DESC
                    With this framework can easily work with custom modal transitions. CustomModalTransition class provides you with all nesessary API, so you should only think about aniamtions.
                   DESC
  s.homepage     = "https://github.com/azimin/AZTransition"
  s.license      = "MIT"
  s.author             = { "Alexander Zimin" => "azimin@me.com" }

  s.ios.deployment_target = '8.0'
  s.source   = {
    :git => 'https://github.com/azimin/AZTransition.git',
    :tag => s.version
  }
  s.source_files  = 'Source/*.swift'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
end
