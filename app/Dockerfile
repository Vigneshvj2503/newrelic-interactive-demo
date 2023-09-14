FROM node:14-alpine

RUN apk --no-cache add --virtual native-deps \
    g++ gcc libgcc libstdc++ linux-headers autoconf automake make nasm python git && \
    npm install --quiet node-gyp -g

RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app/

COPY package.json index.js newrelic.js public /usr/src/app/
COPY views /usr/src/app/views

RUN npm install

EXPOSE 3000

# Create a non-root user and switch to it
RUN addgroup -g 1001 -S appgroup && adduser -u 1001 -S appuser -G appgroup
USER appuser

# Health check
HEALTHCHECK --interval=30s --timeout=5s CMD curl -f http://localhost:3000/ || exit 1

CMD [ "node", "index.js" ]
