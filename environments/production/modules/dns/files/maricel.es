;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This file is centrally managed, any manual changes will be OVERWRITTEN ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

$TTL    3H
@       IN      SOA  @   vps38933.ovh.net. (
                                              2014081601  ; Serial
                                              1D          ; Refresh
                                              1H          ; Retry
                                              1W          ; Expire
                                              3H )        ; Minimum

maricel.es.          IN NS      ns1.jcbdns.com.
maricel.es.          IN NS      ns2.jcbdns.com.
maricel.es.          IN A       92.222.5.238
webmail.maricel.es.  IN A       92.222.5.238
mail.maricel.es.     IN A       92.222.5.238
www.maricel.es.      IN CNAME   maricel.es.
maricel.es.          IN MX      10 mail.maricel.es.


