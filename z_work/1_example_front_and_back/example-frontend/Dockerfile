#example-frontend/Dockerfile

FROM node:16

EXPOSE 5000

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npx browserslist@latest --update-db

RUN npm run build

RUN npm install -g serve

ENV REACT_APP_BACKEND_URL=http://localhost/api

RUN  ["npm", "run", "build"]

CMD ["serve", "-s", "-l", "5000", "build"]
