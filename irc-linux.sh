#! /bin/bash

irc-linux() {
    local day_back="$1"
    [ -z "$day_back" ] && day_back=0
    wget -qO- $(LANG=C TZ=UTC date --date="-${day_back} day" +http://irc.linsovet.org.ua/logs/linux_raw/linux.log.%d%b%Y.txt)
}
