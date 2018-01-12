/etc/kibana/kibana.yml:
  file.managed:
    - makedirs: True
    - source: salt://kibana/templates/kibana.yml.j2
    - template: jinja