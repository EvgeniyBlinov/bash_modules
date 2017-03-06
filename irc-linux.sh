#! /bin/bash

irc-linux() {
    local day_back="$1"
    [ -z "$day_back" ] && day_back=0
    #wget -qO- $(LANG=C TZ=UTC date --date="-${day_back} day" +http://irc.linsovet.org.ua/logs/linux_raw/linux.log.%d%b%Y.txt)
    wget -qO- $(LANG=C TZ=UTC date --date="-${day_back} day" +http://irc.linsovet.org.ua/logs/linux_raw/linux.log.%d%b%Y.txt)|
    grep -av '#linux: mode change'|
    grep -avP '\([^\)]+\) joined #linux'|
    grep -avP '\([^\)]+\) left irc:'|
    grep -avP 'kicked from #linux by bt:'
}
