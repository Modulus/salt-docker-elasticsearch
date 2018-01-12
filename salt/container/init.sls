{% for image in salt['pillar.get']('docker:containers') %}
docker pull {{image}}:
  docker_image.present:
    - name: {{image}}

{% endfor %}

