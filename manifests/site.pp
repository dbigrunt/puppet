# Lo que hi ha aqui es fara a tots els servidors
# Despres podem especificar carecteristiques individuals a cada node

file { "/tmp/testfile":
# Create "/tmp/testfile" if it doesn't exist.
    ensure => present,
    mode   => 644,
    owner  => root,
    group  => root
}


#class prova {
#    file { "/tmp/prova":
#        source => "puppet:///files/tmp/prova",
#    }
#}

#include xen #incluiria totes les classes del modul xen a tots els nodes


node default {
    #include defaultclass
}

import 'nodes/*'
