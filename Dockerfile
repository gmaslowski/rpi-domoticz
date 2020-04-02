FROM balenalib/armv7hf-debian:buster
MAINTAINER Greg Maslowski <gregmaslowski@gmail.com>

RUN apt-get update \
    && apt-get upgrade \
    && apt-get install net-tools netcat \
    && apt-get clean

RUN mkdir /domoticz
RUN mkdir /etc/domoticz

COPY setupVars.conf /etc/domoticz/setupVars.conf

RUN curl -L install.domoticz.com -o install_domoticz.sh
RUN cat install_domoticz.sh | grep -P '\tmakeStartupScript' -v | grep -P '\tstart_service' -v |  grep -P '\tenable_service' -v > install_domoticz_without_startup_scripts.sh

RUN bash ./install_domoticz_without_startup_scripts.sh --unattended

WORKDIR /domoticz

RUN cat updatebeta | grep 'sudo service domoticz.sh restart' -v > updatebetawithoutservice
RUN chmod a+x updatebetawithoutservice && ./updatebetawithoutservice

# a fix for https://github.com/domoticz/domoticz/issues/2362
RUN rm -rf www/js/domoticz.js.gz

CMD ["/domoticz/domoticz", "-www", "8080"]
