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

jcbdns.com.              IN NS    ns1.jcbdns.com.
jcbdns.com.              IN NS    ns2.jcbdns.com.
ns1.jcbdns.com.          IN A     92.222.5.238
ns2.jcbdns.com.          IN A     92.222.5.238
jcbdns.com.              IN A     92.222.5.238
mail.jcbdns.com.         IN A     92.222.5.238
jcbdns.com.              IN MX    10 mail.jcbdns.com.

