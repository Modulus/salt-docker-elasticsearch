base:
  "*":
    - docker
    - container
  "G@roles:elastic or master":
    - match: compound
    - elastic
  "G@roles:kibana":
    - match: compound
    - kibana