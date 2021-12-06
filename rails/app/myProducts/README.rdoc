# API de cadastro de produtos

# Ambiente

- Ruby 2.2.7
- Rails 4

## Como executar o projeto

```bash
## Rode o ambiente docker
$ docker-compose run rails bash

## Entre na pasta do projeto
$ cd myProducts

## Instale as dependências
$ bundle install

## Execute o servidor
$ rails s
```

## Rotas

- POST/products
  - criar produto
- GET/products
  - listar todos produtos
- GET/products/:id
  - listar um produto
- DEL/products/:id
  - apagar um produto
- PUT/products
  - atualizar um produto
