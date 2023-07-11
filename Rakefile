# coding: utf-8
require 'rake'
require 'rspec/core/rake_task'
require 'yaml' # YAMLファイルを処理するために必要

# 実行対象が記載されたYAMLファイルを読み込む
hosts = YAML.load_file('hosts.yml')

desc "Run serverspec to all hosts (=spec:all)"
task :spec    => 'spec:all'

namespace :spec do
  desc "Run serverspec to all hosts (=spec)"
  task :all => hosts.keys.map {|host| 'spec:' + host }
  hosts.keys.each do |host|
    desc "Run serverspec to #{host}"
    RSpec::Core::RakeTask.new(host.to_sym) do |t|
      ENV['TARGET_HOST'] = host
      role = hosts[host][:roles].join(',')
      puts "#####################################################"
      puts "  Target host : #{ENV['TARGET_HOST']}"
      puts "  Role        : #{role}"
      puts "#####################################################"
      t.pattern = 'spec/{' + hosts[host][:roles].join(',') + '}/*_spec.rb'
    end
  end
end
