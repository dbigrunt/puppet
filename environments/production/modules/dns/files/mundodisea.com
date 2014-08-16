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

mundodisea.com.          IN NS      ns1.mundodisea.com.
mundodisea.com.          IN NS      ns2.mundodisea.com.
ns1.mundodisea.com.      IN A       92.222.5.238
ns2.mundodisea.com.      IN A       92.222.5.238
mundodisea.com.          IN A       92.222.5.238
webmail.mundodisea.com.  IN A       92.222.5.238
mail.mundodisea.com.     IN A       92.222.5.238
www.mundodisea.com.      IN CNAME   mundodisea.com.
mundodisea.com.          IN MX      10 mail.mundodisea.com.


