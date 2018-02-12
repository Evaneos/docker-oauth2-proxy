FROM alpine:3.7
MAINTAINER Régis Belson <me@regisbelson.fr>

RUN addgroup -S oauth2_proxy && adduser -S oauth2_proxy oauth2_proxy

RUN apk add --no-cache bash ca-certificates su-exec

ENV GOLANG_VERSION 1.9.4
ENV OAUTH2_PROXY_VERSION_PATCH 2.2.1-alpha-evaneos

RUN set -ex \
    \
	&& apk add --no-cache --virtual .fetch-deps curl \
	&& curl -L "https://github.com/Evaneos/oauth2_proxy/releases/download/v$OAUTH2_PROXY_VERSION_PATCH/oauth2_proxy-$OAUTH2_PROXY_VERSION_PATCH.linux-amd64.go$GOLANG_VERSION.tar.gz" \
	| tar -xz --strip-components=1 -C /usr/local/bin  \
  	&& chmod +x /usr/local/bin/oauth2_proxy \
  	&& apk del .fetch-deps

COPY docker-entrypoint.sh /entrypoint.sh

EXPOSE 4180

ENTRYPOINT ["/entrypoint.sh"] 

CMD ["oauth2_proxy", "--help"]
