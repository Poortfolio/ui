FROM node:20-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
COPY .npmrc* ./
RUN npm ci
COPY . .
RUN npm run build

FROM build AS test
COPY Scripts/test.sh /app/test.sh
RUN chmod +x /app/test.sh && /app/test.sh

FROM nginx:1.25-alpine AS serve
WORKDIR /usr/share/nginx/html
COPY --from=build /app/dist ./
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
