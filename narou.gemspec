# -*- mode: ruby -*-
# -*- coding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "version"
require "fileutils"
module Narou
  def self.create_git_commit_version
    File.write("commitversion", `git describe --always`.strip)
    "commitversion"
  end
end
at_exit do
  if File.exist?("commitversion")
    FileUtils.rm("commitversion")
  end
end
Encoding.default_external = Encoding::UTF_8
Gem::Specification.new do |gem|
  gem.name          = "narou"
  gem.version       = Version
  gem.license       = "MIT"
  gem.authors       = ["whiteleaf7"]
  gem.email         = ["2nd.leaf@gmail.com"]
  gem.homepage      = "http://whiteleaf.hatenablog.com/"
  gem.summary       = %q{Narou.rb ― 小説家になろうダウンローダ＆縦書用整形スクリプト}
  gem.description   = %q{
小説家になろうで公開されている小説の管理、及び電子書籍データへの
変換を支援します。縦書用に特化されており、横書き用に特化されたWEB小説
を違和感なく縦書で読むことが出来るようになります。
}.split("\n").join
  install_message = <<-EOS
#{"*" * 60}

2.9.5 : 2016/07/01
------------------
#### 仕様変更
- WEB UI の Eject ボタンを押した際に、即時取り出しではなく一旦キューに積む様に
  変更しました。これにより変換が終了したら取り外すということが可能になります
	+ すぐに取り外したい場合は Eject ボタン横のドロップダウンメニューから可能です
- Windows でも Eject ボタンに対応しました

#### 修正内容
- Windows 環境において、kindlegen を実行時に何も実行されず mobi ファイルが作成
  出来ない場合がある

#{"*" * 60}
  EOS
  gem.post_install_message = install_message.gsub("\t", "  ")

  gem.required_ruby_version = ">=2.1.0"

  gem.files         = `git ls-files`.split("\n") << Narou.create_git_commit_version
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.add_runtime_dependency 'termcolorlight', '~> 1.0', '>= 1.1.1'
  gem.add_runtime_dependency 'rubyzip', '~> 1.1', '>= 1.1.0'
  gem.add_runtime_dependency 'mail', '2.5.4'
  gem.add_runtime_dependency 'pony', '~> 1.8'
  gem.add_runtime_dependency 'diff-lcs', '~> 1.2', '>= 1.2.5'
  gem.add_runtime_dependency 'sinatra', '~> 1.4', '>= 1.4.5'
  gem.add_runtime_dependency 'sinatra-contrib', '~> 1.4', '>= 1.4.2'
  gem.add_runtime_dependency 'tilt', '~> 2.0', '>= 2.0.1'
  gem.add_runtime_dependency 'sass', '~> 3.4', '>= 3.4.18'
  gem.add_runtime_dependency 'haml', '~> 4.0', '>= 4.0.7'
  gem.add_runtime_dependency 'memoist', '~> 0.11.0'
  gem.add_runtime_dependency 'systemu', '~> 2.6', '>= 2.6.5'
  gem.add_runtime_dependency 'erubis', '~> 2.7'
  gem.add_runtime_dependency 'open_uri_redirections', '~> 0.2', '>= 0.2.1'
end

