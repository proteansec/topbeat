#!/bin/bash
set -e

ELASTICENABLED="${ELASTICENABLED:-true}"
ELASTICHOSTS="${ELASTICHOSTS:-\"localhost:9200\"}"
LOGSTASHENABLED="${LOGSTASHENABLED:-false}"
LOGSTASHHOSTS="${LOGSTASHHOSTS:-\"localhost:5044\", \"logstash:5045\"}"
FILEENABLED="${FILEENABLED:-false}"
FILEPATH="${FILEPATH:-\"/tmp/topbeat\"}"

CONFIGFILE=/etc/topbeat/topbeat.yml
sed 's|{{ELASTICENABLED}}|'"${ELASTICENABLED}"'|' -i "$CONFIGFILE"
sed 's|{{ELASTICHOSTS}}|'"${ELASTICHOSTS}"'|' -i "$CONFIGFILE"
sed 's|{{LOGSTASHENABLED}}|'"${LOGSTASHENABLED}"'|' -i "$CONFIGFILE"
sed 's|{{LOGSTASHHOSTS}}|'"${LOGSTASHHOSTS}"'|' -i "$CONFIGFILE"
sed 's|{{FILEENABLED}}|'"${FILEENABLED}"'|' -i "$CONFIGFILE"
sed 's|{{FILEPATH}}|'"${FILEPATH}"'|' -i "$CONFIGFILE"

# Kibana Dashboards
for es in $(echo "${ELASTICHOSTS}" | sed 's|,\s*| |g'); do
  # strip "
  ses=$(echo $es | tr -d '"')

  # check if already present in ES
  status=$(curl -i -XHEAD "http://${ses}/topbeat-*" 2>/dev/null | egrep "HTTP\/1\..?" | cut -d ' ' -f 2)
  status=${status:-200}

  # add dashboards if not already loaded
  if((${status}!=200)); then
    if [ ! -f /tmp/master.zip ]; then
      curl -L -o /tmp/master.zip https://github.com/elastic/beats-dashboards/archive/master.zip
      unzip /tmp/master.zip -d /tmp
    fi
    cd /tmp/beats-dashboards-master/
    ./load.sh "http://$ses"
  fi
done

case ${1} in
  "app:start")
    topbeat -e -c ${CONFIGFILE}
    ;;
  *)
    /bin/sh -c ${1}
    ;;
esac

exit 0
