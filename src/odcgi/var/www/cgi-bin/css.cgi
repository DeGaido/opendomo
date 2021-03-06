#!/bin/sh
#desc This script selects the right CSS file
# The procedure was done inside the CGI, but this is no longer needed

echo "Content-Type: text/css"
echo "Cache-Control: max-age=3600"
echo

THEMEPATH="/var/www/themes"
SKINPATH="/var/www/skins"

if ! test -f /etc/opendomo/cgi_style; then
	if test -d /var/www/themes/default/; then
		echo "default" > /etc/opendomo/cgi_style
	else
		echo "classic" > /etc/opendomo/cgi_style
	fi
	chown admin:users /etc/opendomo/cgi_style 2>/dev/null
fi
if ! test -f /etc/opendomo/cgi_skin; then
	echo "silver" > /etc/opendomo/cgi_skin
	chown admin:users /etc/opendomo/cgi_skin  2>/dev/null
fi

########### THEME / STYLE ##########
STYLE=`cat /etc/opendomo/cgi_style`

# New feature: customizable style per-user
if ! test -z "$QUERY_STRING"; then
	USER="$QUERY_STRING"
	if test -f /home/$USER/cgi_style; then
		STYLE=`cat /home/$USER/cgi_style`
	fi
fi

# This should NEVER happen
if test -z "$STYLE" || ! test -d "/var/www/themes/$STYLE"; then
	STYLE="default"
	echo $STYLE > /etc/opendomo/cgi_style
	chown admin:users /etc/opendomo/cgi_style 2>/dev/null
fi
echo " /* STYLE $STYLE */"
cat /var/www/themes/$STYLE/main.css
echo
#echo "@import url('/themes/$STYLE/main.css');"
#echo

############# SKIN #################
SKIN=`cat /etc/opendomo/cgi_skin`
# This should NEVER happen
if test -z "$SKIN"; then
	SKIN="default"
	echo $SKIN > /etc/opendomo/cgi_skin
	chown admin:users /etc/opendomo/cgi_skin 2>/dev/null
fi
#echo "@import url('/skins/$SKIN/main.css');"
echo " /* SKIN $SKIN */"
cat /var/www/skins/$SKIN/main.css
echo

