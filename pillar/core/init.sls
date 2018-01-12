docker-pkg:
  lookup:
    pip:
      version: '== 9.0.1'
    python_package: docker==2.5.0
    version: 17.05.*
    refresh_repo: True
    process_signature: /usr/bin/docker
docker:
  compose:
    version: 1.16.1
  install_docker_py: True
  use_old_repo: False


mine_functions:
  network.ip_addrs:
    interface: eth1
    cidr: "192.168.48.0/24"
  vagrant_ip_addrs:
    mine_function: network.ip_addrs
    cidr: "192.168.48.0/24"