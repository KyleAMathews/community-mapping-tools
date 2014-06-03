FROM google/nodejs

EXPOSE 8080

WORKDIR /app

# Install npm modules.
ADD package.json /app/
RUN npm install

ADD . /app

# Build frontend code
RUN npm run build-prod

CMD ["npm", "start"]
