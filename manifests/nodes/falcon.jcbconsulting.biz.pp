node 'falcon.jcbconsulting.biz' inherits base {
    #import profile
    #include vim, syslog-ng
	import "clamav"
	include clamav

}
