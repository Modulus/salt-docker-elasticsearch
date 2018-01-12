/etc/salt/master.d/git_filo_mi_jau.conf:
  file.managed:
    - makedirs: True
    - source: salt://master/files/git.conf