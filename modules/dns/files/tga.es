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

tga.es.          IN NS      ns1.jcbdns.com.
tga.es.          IN NS      ns2.jcbdns.com.
tga.es.          IN A       176.31.188.94
mail.tga.es.     IN A       176.31.188.94
www.tga.es.      IN CNAME   tga.es.
tga.es.          IN MX      10 mail.tga.es.


