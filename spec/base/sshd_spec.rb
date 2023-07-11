require 'spec_helper'

describe service('sshd'), :if => os[:family] == 'redhat' do
  it { should be_running }
end
