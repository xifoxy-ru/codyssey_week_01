FROM nginx:alpine

LABEL org.opencontainers.image.title="codyssey-custom-nginx"
LABEL org.opencontainers.image.description="Custom NGINX image for codyssey workstation mission"

ENV APP_ENV=dev

COPY site/ /usr/share/nginx/html/

EXPOSE 80