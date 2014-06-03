FROM google/nodejs

EXPOSE 8080

WORKDIR /app

# Install npm modules.
ADD package.json /app/
RUN npm install

ADD . /app

CMD ["npm", "start"]
