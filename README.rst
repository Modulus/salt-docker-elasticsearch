Saltstack workshop del 2
###########################

Dere skal nå benytte salt-formulas, pillar, states og salt-mine til å sette opp et elasticsearch cluster. Så skal det importeres data til dette clusteret.

Vi dekker altså

    1. salt-formulas
    2. pillar
    3. states
    4. salt-mine

Dere vil også bli kjent mer med følgende kommandoer

    1. salt
    2. salt-run
    3. salt-call



Docker formula
---------------
Finnes her: https://github.com/saltstack-formulas/docker-formula


Før vi kjører
-------------
.. code:: bash

    vagrant up
    vagrant ssh master

Åpne koden i en editor, f.eks atom og se på hva du skal kjøre av states og pillar før skriver "state.apply"

Oppgave 1 - Docker formula
--------------------------
Vi skal nå legge ut git støtte for salt-masteren


.. code:: bash

    sudo su
    salt master test.ping

    # Åpne salt/master/init.sls og se på denne før du kjører
    salt master state.apply master test=True

    # Config endringer krever reload/restart av salt-master
    service salt-master force-reload

    # Eller
    service salt-master restart



    # Sjekk om docker formula nå er tilgjengelig
    salt-run fileserver.file_list

Oppgave 2 - Installere og konfigurere docker
---------------------------------------------

Vi skal nå installere docker via formulaen vi la inn i oppgave 1

.. code:: bash

    # Åpne pillar/top.sls og finn ut hva som er relevant for docker oppsettet.
    # Dokumentasjon for docker formulaen finnes her: https://github.com/saltstack-formulas/docker-formula.git

    salt "minion*" pillar.items
    salt "*" state.apply docker

    # Kjøre state en gang til
    salt "minion*" state.apply docker



Legg merke til at ingen endringer er utført andre gangen du kjører state ut.

Oppgaver 3 - Salt mine
-------------------------

Åpne pillar/core/init.sls og se etter mine_functions. Det er disse som avgjør hva man kan hente ut av info fra salt-mine

.. code:: bash

    salt "*" mine.update
    salt master mine.get "*" network.ip_addrs
    salt master mine.get "*" vagrant_ip_addrs

Oppgave 4 - Kjøre highstate
-------------------------

.. code:: bash

    salt minion* grains.append roles elastic
    salt master grains.append roles kibana


    # Kjøre highstate
    salt master state.highstate


    salt "minion*" state.highstate

    salt "*" cmd.run "cat /etc/elasticsearch/elasticsearch.yml"

    salt-call cmd.run "curl localhost:9200/_cluster/health?pretty"

    # number_of_nodes skal være 3 her, dersom alt er ok


Oppgave 5 - Importere data til elasticsearch
---------------------------------------------

Dette gjøres via en state

.. code:: bash

    salt master state.apply elastic.data


Oppgave 6 - Sjekke kibana
---------------------------

Dette kan gjøres på master noden

.. code:: bash

    docker logs -f kibana


Når alt ser bra ut her kan du åpne http://192.168.48.10:5601 i nettleseren din.