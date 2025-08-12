# Dockerfile
FROM nginx:alpine
# remove default html (optional)
RUN rm -rf /usr/share/nginx/html/*
COPY build/ /usr/share/nginx/html/
# Optional: you can copy a custom nginx config if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]