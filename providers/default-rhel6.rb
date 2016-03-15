#
# Cookbook Name:: kernel-modules
# Author:: Jeremy MAURO <j.mauro@criteo.com>
#
# Copyright 20012, Societe Publica.
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

provides :kernel_module, platform_family: 'rhel', platform_version: '~> 6.0'

use_inline_resources

action :save do
  # Requirements
  package node['kernel_modules']['packages']

  # Module init loading section
  file modload_file do
    mode '0755'
    content <<_EOF
#!/bin/sh

exec /sbin/modprobe #{new_resource.name} >/dev/null 2>&1
_EOF
    notifies :run, "execute[Loading modules #{new_resource.name}]", :delayed
    action :create
  end

  # Module loading options
  template modprobe_file do # ~FC021
    source 'modprobe.conf.erb'
    mode '0644'
    variables(
      name: new_resource.name,
      config: new_resource.modprobe,
    )
    only_if { new_resource.modprobe }
  end

  # Script taken from '/etc/rc.sysinit#155' in CentOS 6
  execute "Loading modules #{new_resource.name}" do
    command "[ -x #{modload_file} ] && #{modload_file}"
    not_if "lsmod | grep -q #{new_resource.name}"

    action :nothing
  end
end

def modload_file
  ::File.join(node['kernel_modules']['modules_load.d'], new_resource.name + '.modules')
end

def modprobe_file
  ::File.join(node['kernel_modules']['dirs']['modprobe.d'], new_resource.name + '.conf')
end
