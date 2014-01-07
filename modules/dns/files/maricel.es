;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This file is centrally managed, any manual changes will be OVERWRITTEN ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

$TTL    3H
@       IN      SOA  @   vps38933.ovh.net. (
                                              2014040101  ; Serial
                                              1D          ; Refresh
                                              1H          ; Retry
                                              1W          ; Expire
                                              3H )        ; Minimum

maricel.es.          IN NS      ns1.jcbdns.com.
maricel.es.          IN NS      ns2.jcbdns.com.
maricel.es.          IN A       176.31.188.94
webmail.maricel.es.  IN A       176.31.188.94
mail.maricel.es.     IN A       176.31.188.94
www.maricel.es.      IN CNAME   maricel.es.
maricel.es.          IN MX      10 mail.maricel.es.


