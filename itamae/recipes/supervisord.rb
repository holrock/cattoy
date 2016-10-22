package 'supervisor' do
  action :install
end

remote_file "/etc/supervisord.conf" do
  source "remote_files/supervisord.conf"
  notifies :reload, "service[supervisord]"
end

service 'supervisord' do
  action [:enable, :start]
end
