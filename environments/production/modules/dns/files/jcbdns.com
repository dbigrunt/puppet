;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; This file is centrally managed, any manual changes will be OVERWRITTEN ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

$TTL    3H
@       IN      SOA  @   vps38933.ovh.net. (
                                              2013251201  ; Serial
                                              1D          ; Refresh
                                              1H          ; Retry
                                              1W          ; Expire
                                              3H )        ; Minimum

jcbdns.com.              IN NS    ns1.jcbdns.com.
jcbdns.com.              IN NS    ns2.jcbdns.com.
ns1.jcbdns.com.          IN A     176.31.188.94
ns2.jcbdns.com.          IN A     176.31.188.94
jcbdns.com.              IN A     176.31.188.94
mail.jcbdns.com.         IN A     176.31.188.94
jcbdns.com.              IN MX    10 mail.jcbdns.com.

