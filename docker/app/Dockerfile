FROM node:latest

WORKDIR /app

COPY ../package.json ../package-lock.json ./
RUN npm install --only=production

COPY . .

ENV DB_HOST=mysql
ENV DB_USER=mpath_user
ENV DB_PASSWORD=mpath_pass
ENV DB_NAME=mpath

EXPOSE 3000

CMD ["npm", "start"]
