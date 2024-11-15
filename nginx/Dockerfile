FROM nginx:stable

# Add LABEL instructions
LABEL author="HoangBeard - <github.com/hoangbeard>" \
    description="Nginx image for web applications"

# Install the necessary dependencies
RUN apt-get update && apt-get install -y \
    nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/nginx/conf.d/* && \
    rm -rf /usr/share/nginx/html/*

# Copy the nginx config
FROM nginx:stable


# Install the other dependencies
RUN apt-get update && apt-get install -y \
    nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /etc/nginx/conf.d/* && \
    rm -rf /usr/share/nginx/html/*

# Copy Nginx configuration
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/nginx_web.conf /etc/nginx/conf.d/default.conf


# Copy working directory
WORKDIR /var/www/glpi
COPY --chown=www-data:www-data glpi/ ./


RUN chmod 2775 /var/www/glpi && \
    find /var/www/glpi -type d -exec chmod 2775 {} \; && \
    find /var/www/glpi -type f -exec chmod 0664 {} \;
    
# Expose the port the app runs in
EXPOSE 80

# Set default command to run Nginx in foreground mode
CMD ["nginx", "-g", "daemon off;"]
