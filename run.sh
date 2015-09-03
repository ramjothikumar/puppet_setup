mkdir /root/puppet_agent
cd /root/puppet_agent
wget https://raw.githubusercontent.com/ramjothikumar/puppet_setup/master/Dockerfile
docker build -t puppet-agent /root/puppet_agent
