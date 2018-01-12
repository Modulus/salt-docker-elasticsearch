/etc/elasticsearch/elasticsearch.yml:
  file.managed:
    - makedirs: True
    {% if salt["grains.get"]("id") == "master" %}
    - source: salt://elastic/templates/elastic_master.yml.j2
    {% else %}
    - source: salt://elastic/templates/elastic.yml.j2
    {% endif %}
    - template: jinja
    - defaults:
          name: {{salt["grains.get"]("id") }}
          servers:
          {% for server, ip_addrs in salt["mine.get"]("*", "vagrant_ip_addrs").items() %}
              {% if salt["grains.get"]("id") != server %}
            - {{ip_addrs[0] }}
              {% endif %}
          {% endfor %}

/etc/elasticsearch/jvm.options:
  file.managed:
    - source: salt://elastic/templates/jvm.options.j2
    - require_in:
      - docker_container: docker run elasticsearch

sudo sysctl -w vm.max_map_count=262144:
  cmd.run:
    - require_in:
      - file: /etc/sysctl.conf



/etc/sysctl.conf:
  file.replace:
    - pattern: "vm.max_map_count=(.*)"
    - count: 1
    - append_if_not_found: True
    - repl: "vm.max_map_count=262144"
    - require_in:
      - docker_container: docker run elasticsearch

docker run elasticsearch:
  docker_container.running:
    - name: elasticsearch
    - image: docker.elastic.co/elasticsearch/elasticsearch:6.1.1
    - port_bindings:
      - "9200:9200"
      - "9300:9300"
    - binds:
      - "/etc/elasticsearch/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml"
      - "/etc/elasticsearch/jvm.options:usr/share/elasticsearch/config/jvm.options"
    - require:
      - file: /etc/elasticsearch/elasticsearch.yml
    - watch:
      - file: /etc/elasticsearch/elasticsearch.yml
    - environment:
        bootstrap.memory_lock: "true"
        ES_JAVA_OPTS: "-Xms512m -Xmx512m"
