base:
  "L@minion1,minion2,minion1,master":
    - match: list
    - core
  "master":
    - container.kibana
  "minion1":
    - container.elastic
  "minion2":
    - container.elastic