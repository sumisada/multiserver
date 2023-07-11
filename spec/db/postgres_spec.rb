require 'spec_helper'

describe user("#{property[:db_user]}") do
  it { should exist }
end
