node 'falcon.jcbconsulting.biz' inherits base {

    $puppet_fileserver_allowed = [ '*.mundodisea.com', '*.jcbconsulting.biz', 'ks391417.kimsufi.com' ] 

    include clamav
    include puppet::master

}
