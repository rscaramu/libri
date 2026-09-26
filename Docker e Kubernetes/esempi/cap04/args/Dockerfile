FROM alpine:3.20
ARG VERSIONE=sconosciuta
LABEL org.opencontainers.image.version=$VERSIONE
RUN echo "Costruita la versione $VERSIONE" > /versione.txt
CMD ["cat", "/versione.txt"]
