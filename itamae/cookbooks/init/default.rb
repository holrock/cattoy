user_name = node[:user][:name]

execute 'yum update' do
  command 'sudo yum update -y'
end

execute 'groupinstall' do
  command 'sudo yum groupinstall "Development Tools" -y'
end

user user_name do
  password node[:user][:password]
end

execute 'set wheel group' do
 command "usermod -aG wheel #{user_name}"
 not_if "grep -E '^wheel:.+#{user_name}' /etc/group"
end

directory "/home/#{user_name}/.ssh" do
  owner user_name
  group user_name
  mode "700"
end

file "/home/#{user_name}/.ssh/authorized_keys" do
  content node["ssh"]["key"]
  owner user_name
  group user_name
  mode "600"
end

template "/etc/ssh/sshd_config" do
  source "templates/sshd_config"
  owner "root"
  group "root"
  mode   "600"
  variables port: node["ssh"]["port"]
end

# serviceだとvagrantでsshdがrestartしてくれないので
# executeしてsleepする
#service "sshd" do
  #subscribes :restart, "template[/etc/ssh/sshd_config]"
#end
execute "service sshd restart && sleep 1" do
  subscribes :run, "template[/etc/ssh/sshd_config]"
  action :nothing
end

remote_file "/etc/sudoers" do
  source "files/sudoers"
  owner  "root"
  group  "root"
  mode   "440"
end

template "/etc/sysconfig/iptables" do
  source "templates/iptables"
  owner  "root"
  group  "root"
  mode   "600"
  variables ssh_port: node["ssh"]["port"]
end

service "iptables" do
  subscribes :restart, "template[/etc/sysconfig/iptables]"
end
