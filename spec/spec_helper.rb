# coding: utf-8
require 'serverspec'
require 'net/ssh'
require 'highline/import'
require 'yaml'  # YAMLファイルを処理するために必要

# サーバごとの変数が記載されたYAMLファイルを読み込む
host_properties = YAML.load_file('hosts.yml')
# ロールごとの変数が記載されたYAMLファイルを読み込む
common_properties = YAML.load_file('properties.yml')

set :backend, :ssh

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']

# 対象サーバの変数と、実行されるロールの変数をマージして、Property情報に格納
properties = host_properties[host]
properties[:roles].each do |r|
  properties = common_properties[r].merge(host_properties[host]) if common_properties[r]
end
set_property properties

options = Net::SSH::Config.for(host)

options[:user] ||= Etc.getlogin

if ENV['ASK_LOGIN_PASSWORD']
  options[:password] = ask("\nEnter login password: ") { |q| q.echo = false }
else
  options[:password] = ENV['LOGIN_PASSWORD']
end

set :host,        options[:host_name] || host
set :ssh_options, options
