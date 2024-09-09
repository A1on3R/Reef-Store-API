# Stores API

This API allows you to manage stores, items, and ingredients, providing full CRUD (Create, Read, Update, Delete) functionality.

## Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Endpoints](#endpoints)
  - [Stores](#stores)
  - [Items](#items)
  - [Ingredients](#ingredients)

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/A1on3R/Reef-Store-API.git
   
2. Install dependencies:
   ```bash
   bundle install
   
3. Setup the database:
   ```bash
   rails db:create db:migrate db:seed
   
4. Start the server:
   ```bash
   rails server
   
You may have to start your postgres service and create a user named postgres with password postgres (included in the database.yml file)
```bash
sudo service postgresql start
sudo -u postgres psql
```
Then create the user to match the names in my `database.yml` file
```bash
=# create user postgres with password 'postgres';

```
Or you may Alter the `database.yml` file to properly access your postgres

## Usage
Swagger is included so that you can run the app and access at `http://localhost:3000/api-docs`

Also, After setting up, you can interact with the API using tools like `Postman` or `curl`.

## Endpoints

### Stores
you can pass the query parameter `?&starts_with=mysearch` to search by name (Case sensitive)
- **GET** `/stores` – List all stores
- **GET** `/stores/:id` – Get a specific store
- **POST** `/stores` – Create a new store
- **PUT** `/stores/:id` – Update a store
- **DELETE** `/stores/:id` – Delete a store

### Items
you can pass the query parameter `?&starts_with=mysearch` to search by name (Case sensitive)
you can also filter by store by using `&store_id=` to find items by a certain store
- **GET** `/stores/:store_id/items` – List all items in a store
- **GET** `/stores/:store_id/items/:id` – Get a specific item
- **POST** `/stores/:store_id/items` – Create a new item
- **PUT** `/stores/:store_id/items/:id` – Update an item
- **DELETE** `/stores/:store_id/items/:id` – Delete an item

### Ingredients
- **GET** `/items/:item_id/ingredients` – List all ingredients of an item
- **GET** `/items/:item_id/ingredients/:id` – Get a specific ingredient
- **POST** `/items/:item_id/ingredients` – Create a new ingredient
- **PUT** `/items/:item_id/ingredients/:id` – Update an ingredient
- **DELETE** `/items/:item_id/ingredients/:id` – Delete an ingredient
