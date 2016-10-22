user_name = node['user']['name']
ruby_version = node['ruby_version']

package 'openssl-devel'
package 'zlib-devel'
package 'readline-devel'

execute 'rbenv clone' do
  command "git clone https://github.com/rbenv/rbenv.git ~#{user_name}/.rbenv; echo 'export PATH=\"$HOME/.rbenv/bin:$PATH\"' >> ~#{user_name}/.bash_profile; echo 'eval \"$(rbenv init -)\"' >> ~#{user_name}/.bash_profile"
  not_if "test -d ~#{user_name}/.rbenv"
end

execute 'ruby-build' do
  command "git clone https://github.com/rbenv/ruby-build.git ~#{user_name}/.rbenv/plugins/ruby-build"
  not_if "test -d ~#{user_name}/.rbenv/plugins/ruby-build"
end

execute "ruby #{ruby_version}" do
  command "~#{user_name}/.rbenv/plugins/ruby-build/bin/ruby-build #{ruby_version} ~#{user_name}/.rbenv/versions/#{ruby_version}"
  not_if "test -d ~#{user_name}/.rbenv/versions/2.3.1"
end

execute 'rbenv chown' do
  command "chown -R #{user_name}. ~#{user_name}/.rbenv"
  only_if "test -d ~#{user_name}/.rbenv"
end

execute "rbenv global #{ruby_version}" do
  user user_name
  command "/home/#{user_name}/.rbenv/bin/rbenv global #{ruby_version}"
end

execute "gem install bundler" do
  user user_name
  command "/home/#{user_name}/.rbenv/versions/#{ruby_version}/bin/gem install bundler"
  not_if  "/home/#{user_name}/.rbenv/versions/#{ruby_version}/bin/gem list | grep bundler"
end
