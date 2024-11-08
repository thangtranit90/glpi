# Stage 1: Build stage
FROM nginx:alpine AS builder



# Create working directory and download GLPI
WORKDIR /tmp/downloads
RUN echo "Downloading GLPI source..." && \
    curl -L "https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz" -o "glpi-${GLPI_VERSION}.tgz" && \
    mkdir -p /tmp/glpi && \
    tar -xvzf "glpi-${GLPI_VERSION}.tgz" -C /tmp/glpi --strip-components=1

# Create plugins directory and download GLPI SAML plugin
RUN mkdir -p /tmp/glpi/plugins && \
    echo "Downloading GLPI SAML plugin..." && \
    curl -L "https://codeberg.org/QuinQuies/glpisaml/releases/download/${GLPI_SAML_VERSION}/glpisaml.zip" -o "glpisaml.zip" && \
    unzip glpisaml.zip -d /tmp/glpi/plugins/

# Stage 2: Final image
FROM nginx:stable

# Add LABEL instructions
LABEL author="HoangBeard - <github.com/hoangbeard>" \
      description="Nginx image for GLPI web applications with SAML plugin"

# Install additional dependencies (optional)
RUN apt-get update && apt-get install -y \
    nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy Nginx configuration
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/nginx_web.conf /etc/nginx/conf.d/default.conf

# Copy the docker-entrypoint.sh script to the root directory
COPY docker-entrypoint.sh /

# Copy GLPI source and SAML plugin from the builder stage


# Set correct permissions for GLPI directory
RUN chmod 2775 /var/www/glpi && \
    find /var/www/glpi -type d -exec chmod 2775 {} \; && \
    find /var/www/glpi -type f -exec chmod 0664 {} \;

# Set the entrypoint for the container to be the docker-entrypoint.sh script
ENTRYPOINT ["/docker-entrypoint.sh"]

# Expose port 80 for HTTP
EXPOSE 80

# Set default command to run Nginx in foreground mode
CMD ["nginx", "-g", "daemon off;"]
