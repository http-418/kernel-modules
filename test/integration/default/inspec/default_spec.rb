# Cookbook Name:: kernel-modules
# Author:: Jeremy MAURO <j.mauro@criteo.com>
#
# Copyright 2016, Criteo.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

return unless %w[centos redhat].include?(os[:family])

require(File.expand_path('../../helpers/inspec/spec_helper', File.dirname(__FILE__)))

if os[:release].to_i == 7
  describe kernel_module('btusb') do
    it { should be_loaded }
  end

  # First check the init file
  describe file(module_path(:init, 'btusb')) do
    it { should exist }
    its('content') { should match(/# This file was generated by Chef\n# Load btusb at boot\nbtusb\n/) }
  end

  # Then load options
  describe file(module_path(:load, 'btusb')) do
    it { should exist }
    its('content') { should match(/# This file was generated by Chef\nalias btusb1 btusb\noptions btusb ignore_sniffer=0\noptions btusb reset=1\n/) }
  end

  # checking options
  describe file('/sys/module/btusb/parameters/ignore_sniffer') do
    its('content') { should match 'N' }
  end

  describe file('/sys/module/btusb/parameters/reset') do
    its('content') { should match 'Y' }
  end
elsif os[:release].to_i == 6
  describe kernel_module('nfs') do
    it { should be_loaded }
  end

  # First check the init file
  describe file(module_path(:init, 'nfs')) do
    it { should exist }
    its('content') { should match(%r{#!/bin/sh\n# This file was generated by Chef\n\nexec /sbin/modprobe nfs >/dev/null 2>&1\n}) }
  end

  # Then load options
  describe file(module_path(:load, 'nfs')) do
    it { should exist }
    its('content') { should match(/# This file was generated by Chef\nalias nfs4 nfs\noptions nfs enable_ino64=1\noptions nfs nfs4_disable_idmapping=0\n/) }
  end

  # checking options
  describe file('/sys/module/nfs/parameters/enable_ino64') do
    its('content') { should match 'Y' }
  end

  describe file('/sys/module/nfs/parameters/nfs4_disable_idmapping') do
    its('content') { should match 'N' }
  end

end

expected_output = if os[:release].to_i == 6
                    '#!/bin/sh\n# This file was generated by Chef\n\nexec /sbin/modprobe lp >/dev/null 2>&1\n'
                  else
                    '# This file was generated by Chef\n# Load lp at boot\nlp\n'
                  end

# First check the init file
describe file(module_path(:init, 'lp')) do
  it { should exist }
  its('content') { should match(/#{expected_output}/) }
end

# Then load options
describe file(module_path(:load, 'lp')) do
  it { should exist }
  its('content') { should match(/# This file was generated by Chef\nblacklist lp\n/) }
end

describe kernel_module('lp') do
  it { should_not be_loaded }
end
