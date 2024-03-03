FROM node:20.11.0-alpine as build
WORKDIR /build
COPY *.json *.js ./
RUN npm clean-install
COPY src/ ./src
RUN npm run build

FROM ghcr.io/nginxinc/nginx-unprivileged:1.25.3-alpine-slim

# Add nginx configuration
ADD docker/nginx-angular.conf /etc/nginx/conf.d/default.conf
# copy built application from build stage
COPY --from=build --chown=nginx:nginx --chmod=755 /build/dist/frontend-release /usr/share/nginx/html
# Validate the nginx configuration
RUN nginx -t
