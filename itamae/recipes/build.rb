execute 'yum update' do
  command 'sudo yum update -y'
end

user_name = node['user_name']

user "create user" do
  username user_name
  password "wmcpb9ig"
end

execute 'set wheel group' do
 command "usermod -aG wheel #{user_name}"
 not_if "grep -E '^wheel:.+#{user_name}' /etc/group"
end

template "sshd_config" do
  path   "/etc/ssh/sshd_config"
  source "templates/sshd_config"
  mode   "600"
end

service "sshd" do
  subscribes :restart, "template[sshd_config]"
end

#include_recipe 'ruby'
