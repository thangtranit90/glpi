FROM nginx:stable



# Install the necessary dependencies
RUN apt-get update && apt-get install -y \
    nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/nginx/conf.d/* && \
    rm -rf /usr/share/nginx/html/*

# Copy the nginx config
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY /nginx/nginx_web.conf /etc/nginx/conf.d/default.conf

# Copy working directory
WORKDIR /var/www/glpi
COPY --chown=www-data:www-data glpi/ ./


# Expose the port the app runs in
EXPOSE 80
