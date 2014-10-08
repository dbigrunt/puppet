;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This file is centrally managed, any manual changes will be OVERWRITTEN ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

$TTL    3H
@       IN      SOA  @   vps38933.ovh.net. (
                                              2014100801  ; Serial
                                              1D          ; Refresh
                                              1H          ; Retry
                                              1W          ; Expire
                                              3H )        ; Minimum

mundodisea.com.      IN NS      ns1.jcbdns.com.
mundodisea.com.      IN NS      ns2.jcbdns.com.
mundodisea.com.      IN A       92.222.5.238
mail.mundodisea.com. IN A       92.222.5.238
www.mundodisea.com.  IN CNAME   mundodisea.com.
mundodisea.com.      IN MX      10 mail.mundodisea.com.


