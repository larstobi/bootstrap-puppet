Instructions
============

Puppet Master
-------------
Get the code out to a machine to become a Puppet master, and run:

    # ./bootstrap.master.sh

Puppet Node
-----------
Make the files available at an internal web server, you can wget the
bootstrap.client.sh file and execute it, and it will download the required 
extra files for you.

    # wget --quiet --no-check-certificate https://puppet.example.net/bootstrap.client.sh \
    && chmod +x bootstrap.client.sh \
    && ./bootstrap.client.sh
