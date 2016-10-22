# build nginx for http2
user_name = node['user']['name']
nginx_version = node['nginx_version']
libressl_version = node['libressl_version']

package 'wget'
package 'pcre-devel'
package 'openssl-devel'
package 'libxslt-devel'
package 'gd-devel'
package 'perl-ExtUtils-Embed'

build_dir = "/home/#{user_name}/tools/nginx"

directory build_dir do
  user user_name
end

execute "wget -O - https://nginx.org/download/#{nginx_version}.tar.gz | tar zxf -" do
  user user_name
  cwd build_dir
  not_if "test -d #{build_dir}/#{nginx_version}"
end

execute "wget -O - https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/#{libressl_version}.tar.gz | tar zxf -" do
  user user_name
  cwd build_dir
  not_if "test -d #{build_dir}/#{libressl_version}"
end

execute "./configure --prefix=/opt/#{nginx_version} --with-http_ssl_module --with-http_gzip_static_module --with-http_stub_status_module --with-http_v2_module --with-http_realip_module --with-openssl=../#{libressl_version} --with-cc-opt='-O2 -g -pipe -Wall -Wp,-D_FORTIFY_SOURCE=2 -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -march=native' --with-ld-opt=' -Wl,-E -lrt' && make && sudo make install" do
  user user_name
  cwd "#{build_dir}/#{nginx_version}"
  not_if "test -d /opt/#{nginx_version}"
end
