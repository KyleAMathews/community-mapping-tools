FROM google/nodejs

WORKDIR /app

# Install npm modules.
ADD package.json /app/
RUN npm install

ADD . /app

# Build frontend code
RUN npm run build-prod

ENV DOCKER true
EXPOSE 8080

CMD ["npm", "start"]
