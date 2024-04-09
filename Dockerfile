FROM alpine:latest as build-env 

RUN apk add make md4c

WORKDIR /site
COPY . .
RUN make build
RUN mkdir out 
RUN cp *.html ./out/

FROM ghcr.io/nickorlow/anthracite:0.2.1
COPY --from=build-env /site/out/ /www/
