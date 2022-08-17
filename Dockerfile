FROM ghcr.io/graalvm/native-image AS build
ENV CLJFMT_VERSION=0.8.2
COPY ./cljfmt/cljfmt /app
WORKDIR /app
RUN curl -O https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    chmod +x lein && \
    mv lein /usr/bin/lein && \
    lein upgrade
RUN lein native-image

FROM fedora
COPY --from=build /app/target/cljfmt /usr/bin/
ENTRYPOINT ["/usr/bin/cljfmt"]
CMD []
