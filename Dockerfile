FROM alpine/curl:3.14 as checkout
ENV CLJFMT_VERSION=0.9.0
RUN curl -L -s https://github.com/weavejester/cljfmt/archive/refs/tags/$CLJFMT_VERSION.tar.gz \
       | tar xvz -C /tmp \
    && mv /tmp/cljfmt-$CLJFMT_VERSION/cljfmt /app

FROM ghcr.io/graalvm/native-image:22.2.0 AS build
COPY --from=checkout /app /app
WORKDIR /app/
RUN curl -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x lein && \
    mv lein /usr/bin/lein && \
    lein upgrade
RUN lein native-image

FROM fedora:36
COPY --from=build /app/target/cljfmt /usr/bin/
ENTRYPOINT ["/usr/bin/cljfmt"]
CMD []
