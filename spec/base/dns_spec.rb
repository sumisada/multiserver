require 'spec_helper'

describe file('/etc/resolv.conf') do
  its(:content) { should match /^nameserver #{property[:dns_server]}/ }
end
