FROM node:20 AS build-env

ARG TARGETARCH

WORKDIR /app
RUN npm install onchange
RUN curl -fLo mimirtool "https://github.com/grafana/mimir/releases/latest/download/mimirtool-linux-$TARGETARCH" && chmod +x mimirtool


FROM node:alpine3.19
ENV NODE_ENV=production
COPY --from=build-env /app/mimirtool /app/mimirtool

WORKDIR /app
RUN npm install onchange && apk add --no-cache tini
COPY mimir_script.sh /app/mimir_script.sh
RUN chmod +x mimir_script.sh
USER 65534:65534
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/app/node_modules/.bin/onchange", "/app/alerts/*","--", "/app/mimir_script.sh", "{{event}}", "{{file}}"]
