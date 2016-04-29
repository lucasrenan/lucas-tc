# Lucas TC

This project is a tiny rails-api app secured by basic auth. Basically, there are users and posts.

User roles:

- Admin has access to everything
- User can read all, create all, but update and delete only his records
- Guest has only read access

Responses are following json api spec. It's currently using a custom implementation, but in the future, it should use active model serializer json_api adapter or anything else.

```json
{
  data: {},
  errors: {},
  meta: { api_version: '1' }
}
```

## Getting started

Fork the repo and then clone it.

Install gems
```bash
  bundle install
```

Run migrations
```bash
  rake db:migrate
```

Populate database
```
  rake db:seed
```

Start the server
```bash
  rails s
```

### Project dependencies
 - Ruby ~> 2.3.0
 - Rails '>= 5.0.0.beta3', '< 5.1'
 - Postgres

## Using the api

### Routes
```
  Prefix Verb   URI Pattern             Controller#Action
v1_login POST   /v1/login(.:format)     v1/authentication#create
v1_posts GET    /v1/posts(.:format)     v1/posts#index
         POST   /v1/posts(.:format)     v1/posts#create
 v1_post GET    /v1/posts/:id(.:format) v1/posts#show
         PATCH  /v1/posts/:id(.:format) v1/posts#update
         PUT    /v1/posts/:id(.:format) v1/posts#update
         DELETE /v1/posts/:id(.:format) v1/posts#destroy
```

Login
```bash
curl -X POST http://localhost:3000/v1/login -d "email=admin@test.com&password=123456"
```

```json
{"data":{"id":1,"email":"admin@test.com","role":"admin","access_token":"-mbJUFUJdwG3zGCxBSZa"},"errors":{},"meta":{"api_version":"1"}}
```

Listing posts
```bash
curl http://localhost:3000/v1/posts -H "Authorization: Token -mbJUFUJdwG3zGCxBSZa"
```

```json
{"data":[{"id":1,"title":"admin post","text":"text","user_id":1},{"id":2,"title":"user post","text":"text","user_id":2},{"id":3,"title":"guest post","text":"text","user_id":3}],"errors":{},"meta":{"api_version":"1"}}
```

Updating post
```bash
curl -X PATCH http://localhost:3000/v1/posts/1 -H "Authorization: Token -mbJUFUJdwG3zGCxBSZa" -d "text=updated"
```

```json
{"data":{"id":1,"title":"admin post","text":"updated","user_id":1},"errors":{},"meta":{"api_version":"1"}}
```

## Heroku url

[https://lucas-tc.herokuapp.com/](https://lucas-tc.herokuapp.com/)

## TODO

- rescue_from invalid token error
- add action to logout
- include dates into payloads (ISO-8601)
- should it include self link into payloads?
- should it render erros in json format for not found routes?
- code climate
- travis ci
- code coverage
