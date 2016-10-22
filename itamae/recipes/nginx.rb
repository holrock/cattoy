package 'nginx' do
  action :install
end

remote_file "/etc/nginx/nginx.conf" do
  source "remote_files/nginx.conf"
  notifies :reload, "service[nginx]"
end

service 'nginx' do
  action [:enable, :start]
end
