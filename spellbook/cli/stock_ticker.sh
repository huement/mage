while [ ! -e /tmp/nt_stop ];do n=$(wget -q -O - http://news.yahoo.com/rss/|awk 'BEGIN{FS="<item><title>"}{for(i=2;i<=NF;i++){sub(/<.*/," ",$i);printf("%s",$i)}}');for i in $(eval echo {0..${#n}});do echo -ne "\e[s\e[0;0H${n:$i:$((COLUMNS - 1))}\e[u";sleep .10;[ -e /tmp/nt_stop ] && break;done;done &