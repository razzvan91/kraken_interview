FROM  ubuntu:20.10
#problem 1

# Main source of inspiration and copy for the whole docker image and entry script is:
# https://github.com/uphold/docker-litecoin-core/blob/master/0.18/Dockerfile
RUN apt-get update -y && apt-get install -y curl gnupg  && apt-get clean

ENV LTC_VERS=0.18.1
ENV LTC_SIG=FE3348877809386C
ENV GOSU_VERS=1.14
ENV GOSU_SIG=B42F6819007F00F88E364FD4036A9C25BF357DD4
ENV LTC_DATA=/home/ltcuser/.litecoin


RUN useradd -r ltcuser

#Decided to check multiple servers because pgp.mit.edu was not working wheen I first tried it
#I have never used gpg so far and got my inspiration from the above repo.

#Below we are receiving/adding keys to gpg keychain

RUN gpg --no-tty --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "$LTC_SIG" || \
    gpg --no-tty --keyserver keyserver.pgp.com --recv-keys "$LTC_SIG" || \
    gpg --no-tty --keyserver ha.pool.sks-keyservers.net --recv-keys "$LTC_SIG" || \
    gpg --no-tty --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$LTC_SIG" || \
    gpg --no-tty --keyserver hkps://keys.openpgp.org --recv-keys "$LTC_SIG"


RUN curl -SLO https://download.litecoin.org/litecoin-${LTC_VERS}/linux/litecoin-${LTC_VERS}-x86_64-linux-gnu.tar.gz && \
    curl -SLO https://download.litecoin.org/litecoin-${LTC_VERS}/linux/litecoin-${LTC_VERS}-linux-signatures.asc


#Verifying the asc file
RUN gpg --verify litecoin-${LTC_VERS}-linux-signatures.asc \
#    Here we check if the hash of the download is similar to the one present in the asc file
  && grep $(sha256sum litecoin-${LTC_VERS}-x86_64-linux-gnu.tar.gz | awk '{ print $1 }') litecoin-${LTC_VERS}-linux-signatures.asc \
#  Extracting the daemon
  && tar --strip=2 -xzf *.tar.gz -C /usr/local/bin \
  && rm *.tar.gz

RUN gpg --no-tty --keyserver hkps://keys.openpgp.org --recv-keys "$GOSU_SIG"

# We need gosu to run commands with sudo because sudo is misbehaving
RUN curl -o /usr/local/bin/gosu -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERS}/gosu-$(dpkg --print-architecture) \
  && curl -o /usr/local/bin/gosu.asc -fSL https://github.com/tianon/gosu/releases/download/${GOSU_VERS}/gosu-$(dpkg --print-architecture).asc \
  && gpg --verify /usr/local/bin/gosu.asc \
  && rm /usr/local/bin/gosu.asc \
  && chmod +x /usr/local/bin/gosu

COPY entry.sh /entry.sh
ENTRYPOINT ["./entry.sh"]
CMD ["litecoind"]
