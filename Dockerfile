FROM        golang:1.18.4-alpine3.16 AS BUILD_IMAGE
RUN         apk add --update --no-cache curl
WORKDIR     /go/croc
COPY        croc.version .
RUN         curl -#L -o croc.tar.gz https://api.github.com/repos/schollz/croc/tarball/v$(cat croc.version) && \
            tar -xzf croc.tar.gz --strip 1 &&  \
            go get -d && \
            go build -ldflags="-s -w"

FROM        alpine:3.16.0
RUN         apk add --update --no-cache tini
COPY        --from=BUILD_IMAGE /go/croc/croc /go/croc/croc-entrypoint.sh /
EXPOSE 9009
EXPOSE 9010
EXPOSE 9011
EXPOSE 9012
EXPOSE 9013
ENTRYPOINT ["/croc-entrypoint.sh"]
CMD ["relay localhost:9009"]
