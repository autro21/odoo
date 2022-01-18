#!/bin/bash
#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
green=`curl -L --connect-timeout 120 -I http://localhost/web/database/selector 2>/dev/null | head -n 1 | cut -d$' ' -f2`
blue=`curl -L --connect-timeout 120 -I http://localhost:81/web/database/selector 2>/dev/null | head -n 1 | cut -d$' ' -f2`
red=`curl -L --connect-timeout 120 -I http://localhost:82/web/database/selector 2>/dev/null | head -n 1 | cut -d$' ' -f2`
#echo -e "response is: $green $blue $red \\n"
if [[ "$green" != "200" || "$blue" != "200" || "$red" != "200" ]]
then
	echo "Nginx is not fine please check h1 and debug it" | mail -s "h1 logs" hesham.ragab.sd@gmail.com
fi

reps=`psql -h 46.101.55.93 -U red -x -c "select * from pg_is_in_recovery();" | grep "pg_is_in_recovery | t"`

if [[ "$reps" != "pg_is_in_recovery | t" ]]
then
	echo "replica is not fine please check h2 and debug it" | mail -s "h2 replica logs" hesham.ragab.sd@gmail.com
fi
