<#
    Start PHP Server on Source
    directory using it as www
    root
#>

docker run --name Webserver -p 80:80 -d drupalci:php-5.5.38-apache