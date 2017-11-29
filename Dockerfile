FROM resin/rpi-raspbian:jessie
MAINTAINER Greg Maslowski <gregmaslowski@gmail.com>

RUN apt-get update
RUN apt-get upgrade
RUN apt-get install net-tools

RUN mkdir /domoticz
RUN mkdir /etc/domoticz

COPY setupVars.conf /etc/domoticz/setupVars.conf

RUN curl -L install.domoticz.com -o install_domoticz.sh
RUN cat install_domoticz.sh | grep -P '\tmakeStartupScript' -v | grep -P '\tstart_service' -v |  grep -P '\tenable_service' -v > install_domoticz_without_startup_scripts.sh

RUN bash ./install_domoticz_without_startup_scripts.sh --unattended

WORKDIR /domoticz

RUN cat updatebeta | grep 'sudo service domoticz.sh restart' -v > updatebetawithoutservice
RUN chmod a+x updatebetawithoutservice && ./updatebetawithoutservice

CMD ["/domoticz/domoticz", "-www", "8080"]
