FROM node:18-alpine AS base

WORKDIR /app

RUN npm install -g pnpm

COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile


COPY . /app


RUN pnpm build
RUN cp -r public .next/standalone/ && cp -r .next/static .next/standalone/.next/

RUN pnpm prune --prod

RUN rm -rf node_modules



FROM node:18-alpine AS production

RUN npm install -g pnpm

ENV NODE_ENV=production

WORKDIR /app

COPY --from=base /app ./

# RUN pnpm install --prod --frozen-lockfile

EXPOSE 3000

CMD ["node", ".next/standalone/server.js"]
