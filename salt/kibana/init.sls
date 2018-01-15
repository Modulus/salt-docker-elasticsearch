{% set interface = salt['network.interface']('eth1')  %}

include:
  - elastic

/etc/kibana/kibana.yml:
  file.managed:
    - makedirs: True
    - source: salt://kibana/templates/kibana.yml.j2
    - template: jinja
    - defaults:
          ip: {{interface[0].address}}

    - require:
      - sls: elastic

docker run docker.elastic.co/kibana/kibana:6.1.1:
  docker_container.running:
    - image: docker.elastic.co/kibana/kibana-oss:6.1.1
    - name: kibana
    - port_bindings:
      - "5601:5601"
    - binds:
      - "/etc/kibana/kibana.yml:/usr/share/kibana/config/kibana.yml"
    - restart_policy: on-failure:7
    - require:
      - file: /etc/kibana/kibana.yml
      - sls: elastic