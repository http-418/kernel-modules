#
# Cookbook Name::	kernel-modules
# Description::		inspec test for kernel-modules
# Recipe::				default_spec
# Author::        Jeremy MAURO (j.mauro@criteo.com)
#
#
#

describe kernel_module('lp') do
  it { should be_loaded }
end
