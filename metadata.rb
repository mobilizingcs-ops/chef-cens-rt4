name 'cens-rt4'
maintainer 'Steve Nolen'
maintainer_email 'technolengy@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures cens-rt4'
long_description 'Installs/Configures cens-rt4'
version '0.0.5'

%w(ubuntu).each do |os|
  supports os
end

depends 'nginx', '~>2.7.6'
