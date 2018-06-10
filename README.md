# apache-ruby

```bash
$ docker run --name ar -dit docker.icasei.com.br/apache-ruby
785188899ef24b63476ac3f3c276f6dbe6aa8f729ea0598b3284e888378eb4f2

$ docker ps
CONTAINER ID        IMAGE                              COMMAND             CREATED                  STATUS              PORTS               NAMES
785188899ef2        docker.icasei.com.br/apache-ruby   "./start.sh"        Less than a second ago   Up 17 seconds                           ar

$ docker exec -it ar /bin/bash
root@785188899ef2:/# ls
bin   dev  home  lib64	mnt  proc  run	 srv	   sys	usr
boot  etc  lib	 media	opt  root  sbin  start.sh  tmp	var

root@785188899ef2:/# hostname -I
172.17.0.2

root@785188899ef2:/# cat /etc/os-release 
PRETTY_NAME="Debian GNU/Linux 9 (stretch)"
NAME="Debian GNU/Linux"
VERSION_ID="9"
VERSION="9 (stretch)"
ID=debian
HOME_URL="https://www.debian.org/"
SUPPORT_URL="https://www.debian.org/support"
BUG_REPORT_URL="https://bugs.debian.org/"

root@785188899ef2:/# service apache2 status
[ ok ] apache2 is running.

root@785188899ef2:/# apache2ctl -M
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
Loaded Modules:
 core_module (static)
 so_module (static)
 watchdog_module (static)
 http_module (static)
 log_config_module (static)
 logio_module (static)
 version_module (static)
 unixd_module (static)
 access_compat_module (shared)
 alias_module (shared)
 auth_basic_module (shared)
 authn_core_module (shared)
 authn_file_module (shared)
 authz_core_module (shared)
 authz_host_module (shared)
 authz_user_module (shared)
 autoindex_module (shared)
 deflate_module (shared)
 dir_module (shared)
 env_module (shared)
 filter_module (shared)
 mime_module (shared)
 mpm_event_module (shared)
 negotiation_module (shared)
 reqtimeout_module (shared)
 setenvif_module (shared)
 status_module (shared)
 
root@785188899ef2:/# ls -la /var/log/apache2
total 12
drwxr-x--- 1 root adm  4096 Jun  9 02:07 .
drwxr-xr-x 1 root root 4096 Jun  9 02:07 ..
-rw-r----- 1 root adm     0 Jun  9 02:07 access.log
-rw-r----- 1 root adm   461 Jun  9 13:53 error.log
-rw-r----- 1 root adm     0 Jun  9 02:07 other_vhosts_access.log
 
root@785188899ef2:/# cat /var/log/apache2/error.log 
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
[Sat Jun 09 13:53:04.173475 2018] [mpm_event:notice] [pid 15:tid 140045873198272] AH00489: Apache/2.4.25 (Debian) configured -- resuming normal operations
[Sat Jun 09 13:53:04.173606 2018] [core:notice] [pid 15:tid 140045873198272] AH00094: Command line: '/usr/sbin/apache2 -D FOREGROUND'

root@91d01fe602f2:/# curl -4 http://172.17.0.2

root@785188899ef2:/# exit
exit

$ docker rm -f ar
ar
```

```bash
$ docker run --name ar -dit -p 80:80 docker.icasei.com.br/apache-ruby
aad79382d5fb0b55a1f24f1fca257a77bbe0bf275ef34469f43fa645405b271a

$ docker ps
CONTAINER ID        IMAGE                              COMMAND             CREATED                  STATUS              PORTS                NAMES
aad79382d5fb        docker.icasei.com.br/apache-ruby   "./start.sh"        Less than a second ago   Up 28 seconds       0.0.0.0:80->80/tcp   ar

$ curl http://localhost

$ docker exec -it ar /bin/bash

root@aad79382d5fb:/# ls -la /etc/apache2/
total 80
drwxr-xr-x 8 root root  4096 Jun  9 14:02 .
drwxr-xr-x 1 root root  4096 Jun  9 14:09 ..
-rw-r--r-- 1 root root  7224 Mar 31 08:47 apache2.conf
drwxr-xr-x 2 root root  4096 Jun  9 14:02 conf-available
drwxr-xr-x 2 root root  4096 Jun  9 14:02 conf-enabled
-rw-r--r-- 1 root root  1782 Mar 30 15:07 envvars
-rw-r--r-- 1 root root 31063 Mar 30 15:07 magic
drwxr-xr-x 2 root root  4096 Jun  9 14:02 mods-available
drwxr-xr-x 2 root root  4096 Jun  9 14:02 mods-enabled
-rw-r--r-- 1 root root   320 Mar 30 15:07 ports.conf
drwxr-xr-x 2 root root  4096 Jun  9 14:02 sites-available
drwxr-xr-x 2 root root  4096 Jun  9 14:02 sites-enabled

root@aad79382d5fb:/# cat /etc/apache2/ports.conf 
# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 80

<IfModule ssl_module>
	Listen 443
</IfModule>

<IfModule mod_gnutls.c>
	Listen 443
</IfModule>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet

root@aad79382d5fb:/# cat /etc/apache2/apache2.conf 
# This is the main Apache server configuration file.  It contains the
# configuration directives that give the server its instructions.
# See http://httpd.apache.org/docs/2.4/ for detailed information about
# the directives and /usr/share/doc/apache2/README.Debian about Debian specific
# hints.

root@aad79382d5fb:/# cat /etc/apache2/envvars
# envvars - default environment variables for apache2ctl

# this won't be correct after changing uid
unset HOME

# for supporting multiple apache2 instances
if [ "${APACHE_CONFDIR##/etc/apache2-}" != "${APACHE_CONFDIR}" ] ; then
	SUFFIX="-${APACHE_CONFDIR##/etc/apache2-}"
else
	SUFFIX=
fi

# Since there is no sane way to get the parsed apache2 config in scripts, some
# settings are defined via environment variables and then used in apache2ctl,
# /etc/init.d/apache2, /etc/logrotate.d/apache2, etc.
export APACHE_RUN_USER=www-data
export APACHE_RUN_GROUP=www-data
# temporary state file location. This might be changed to /run in Wheezy+1
export APACHE_PID_FILE=/var/run/apache2$SUFFIX/apache2.pid
export APACHE_RUN_DIR=/var/run/apache2$SUFFIX
export APACHE_LOCK_DIR=/var/lock/apache2$SUFFIX
# Only /var/log/apache2 is handled by /etc/logrotate.d/apache2.
export APACHE_LOG_DIR=/var/log/apache2$SUFFIX

## The locale used by some modules like mod_dav
export LANG=C
## Uncomment the following line to use the system default locale instead:
#. /etc/default/locale

export LANG

## The command to get the status for 'apache2ctl status'.
## Some packages providing 'www-browser' need '--dump' instead of '-dump'.
#export APACHE_LYNX='www-browser -dump'

## If you need a higher file descriptor limit, uncomment and adjust the
## following line (default is 8192):
#APACHE_ULIMIT_MAX_FILES='ulimit -n 65536'

## If you would like to pass arguments to the web server, add them below
## to the APACHE_ARGUMENTS environment.
#export APACHE_ARGUMENTS=''

## Enable the debug mode for maintainer scripts.
## This will produce a verbose output on package installations of web server modules and web application
## installations which interact with Apache
#export APACHE2_MAINTSCRIPT_DEBUG=1

root@aad79382d5fb:/# cat /etc/apache2/sites-enabled/000-default.conf 
<VirtualHost *:80>
	# The ServerName directive sets the request scheme, hostname and port that
	# the server uses to identify itself. This is used when creating
	# redirection URLs. In the context of virtual hosts, the ServerName
	# specifies what hostname must appear in the request's Host: header to
	# match this virtual host. For the default virtual host (this file) this
	# value is not decisive as it is used as a last resort host regardless.
	# However, you must set it for any further virtual host explicitly.
	#ServerName www.example.com

	ServerAdmin webmaster@localhost
	DocumentRoot /var/www/html

	# Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
	# error, crit, alert, emerg.
	# It is also possible to configure the loglevel for particular
	# modules, e.g.
	#LogLevel info ssl:warn

	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined

	# For most configuration files from conf-available/, which are
	# enabled or disabled at a global level, it is possible to
	# include a line for only one particular virtual host. For example the
	# following line enables the CGI configuration for this host only
	# after it has been globally disabled with "a2disconf".
	#Include conf-available/serve-cgi-bin.conf
</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet
root@aad79382d5fb:/# ls /var/www/html
index.html

root@aad79382d5fb:/# apache2ctl configtest
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
Syntax OK

root@aad79382d5fb:/# exit
exit

$ docker rm -f ar
ar
```

```bash
$ docker run --name ar -dit -p 80:80 -p 443:443 docker.icasei.com.br/apache-ruby

```