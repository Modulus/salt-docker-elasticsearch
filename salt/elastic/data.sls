/tmp/shake.json:
  file.managed:
    - source: salt://elastic/templates/shakespeare_6.0.json

/tmp/shake_mapping.json:
  file.managed:
    - source: salt://elastic/templates/shake_mapping.json

curl mappings:
  cmd.run:
    - cwd: /tmp
    - name: "curl -H 'Content-Type: application/x-ndjson' -XPOST 'localhost:9200/bank/account/_bulk?pretty' --data-binary @shake_mapping.json"
    - require:
      - file: /tmp/shake_mapping.json



curl json:
  cmd.run:
    - cwd: /tmp
    - name: "curl -H 'Content-Type: application/x-ndjson' -XPOST 'localhost:9200/shakespeare/doc/_bulk?pretty' --data-binary @shake.json"
    - require:
      - file: /tmp/shake.json
      - cmd: curl mappings