name               'kernel-modules'
maintainer         'Criteo'
maintainer_email   'sre-core@criteo.com'
license            'Apache v2.0'
description        'Manage kernel modules on linux'
long_description   IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url         'https://github.com/criteo-cookbooks/kernel-modules.git'
source_url         'https://github.com/criteo-cookbooks/kernel-modules.git'
version            '0.1.0'
chef_version       '>= 12.5.1' if respond_to?(:chef_version)
supports           'rhel', '>= 6'
supports           'centos', '>= 6'
