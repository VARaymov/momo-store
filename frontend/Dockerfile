FROM node:16 as builder
WORKDIR /app
COPY . .
RUN npm install \
&& npm run build

FROM nginxproxy/nginx-proxy
COPY --from=builder /app/dist/ /usr/share/nginx/html/
COPY --from=builder /app/nginx.tmpl /app/nginx.tmpl
EXPOSE 80
ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]
