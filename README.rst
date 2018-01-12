Docker formula
---------------
Finnes her: https://github.com/saltstack-formulas/docker-formula


Før vi kjører
-------------
..code: bash

    vagrant up
    vagrant ssh master

Oppgave 1
---------
Vi skal nå legge ut git støtte for salt-masteren


.. code:: bash
    sudo su
    salt master test.ping
    salt master state.apply master test=True

    # Config endringer krever restart av salt-master
    service salt-master restart

    # Sjekk om docker formula nå er tilgjengelig
    salt-run fileserver.file_list

Oppgave 2 - Installere og konfigurere docker
---------------------------------------------

Vi skal nå installere docker via formulaen vi la inn i oppgave 1

.. code:: bash
    salt "minion*" pillar.items
    salt "*" state.apply docker

    # Kjøre state en gang til
    salt "minion*" state.apply docker



Legg merke til at ingen endringer er utført andre gangen du kjører state ut.

Oppgaver 3 - Salt mine
-------------------------

.. code:: bash

    salt "*" mine.update
    salt master mine.get "*" network.ip_addrs
    salt master mine.get "*" vagrant_ip_addrs

Oppgave 4 - Sette grains
-------------------------

.. code:: bash

    salt minion* grains.append roles elastic
    salt master grains.append roles kibana


    # Kjøre highstate
    salt "*" state.highstate

    salt "*" cmd.run "cat /etc/elasticsearch/elasticsearch.yml"