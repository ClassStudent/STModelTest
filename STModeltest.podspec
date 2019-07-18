Pod::Spec.new do |s|
    s.name         = "STModelTest"
    s.version      = "0.0.1"
    s.summary      = "STModel"
    s.description  = <<-DESC
                    this is STModel.
                   DESC
    s.homepage     = "https://github.com/ClassStudent/STModelTest"
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { '周远明' => '1403940959@qq.com' }
    s.source           = { :git => 'https://github.com/ClassStudent/STModelTest.git', :tag => s.version.to_s }
    s.ios.deployment_target = '9.0'
    s.source_files = 'STModel/**/*.{h,m}'

end

