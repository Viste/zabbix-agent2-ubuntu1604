# zabbix-agent2-ubuntu1604
Ah shit, here we go again

build zabbix-agent2 deb package for ubuntu1604(not supported by zabbix :/ only 18.04+) but for local use 16 still ok(with some kernel patches) on old PC/Server/NAS 

basic for 5.4.12(yes its not LTS but маемо шо маемо) change version in rules and build_zbx.bash files if you need another(go version also must match your wants) 


I am not sure about pre/post files and correct filling of rules, so I do not recommend using this package in production.
This is my first experience in building a package for deb systems, in rhel everything is much easier and more transparent (in my opinion).  So if you know how to edit pre/post and rules/control files to use the package safely in production contact me and offer your suggestions, I will be very happy!
