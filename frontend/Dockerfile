FROM node:16 as builder
WORKDIR /app
COPY . .
RUN npm install \
&& npm run build

FROM nginxproxy/nginx-proxy
RUN addgroup --system frontuser && \
		adduser --system --shell /bin/false --no-create-home --disabled-login --ingroup frontuser frontuser && \
		addgroup --gid 997 docker && \
		usermod -aG docker frontuser && \
		chown -R frontuser:frontuser /app && chmod -R 755 /app && \
		chown -R frontuser:frontuser /var/cache/nginx && \
	    chown -R frontuser:frontuser /var/log/nginx && \
	    chown -R frontuser:frontuser /etc/nginx/conf.d && \
		touch /var/run/nginx.pid && \
		chown -R frontuser:frontuser /var/run/nginx.pid && \
		mkdir -p /etc/nginx/dhparam && \
		chown frontuser:frontuser /etc/nginx/dhparam 

COPY --chown=frontuser:frontuser --from=builder /app/dist/ /usr/share/nginx/html/
COPY --chown=frontuser:frontuser --from=builder /app/nginx.tmpl /app/nginx.tmpl

ENV NODE_ENV="production"
ENV VUE_APP_API_URL="backend:8081"

EXPOSE 80
USER frontuser
ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["forego", "start", "-r"]
