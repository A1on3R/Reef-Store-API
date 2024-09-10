# Stores API

This API allows you to manage stores, items, and ingredients, providing full CRUD (Create, Read, Update, Delete) functionality.

## Overview of Solution
 We were able to include implementations of
 - Rails API that manages stores, items, and ingredients
 - All CRUD functionality for the 3 basic models
 - Pagination and filtering
 - Rspec tests that work with Swagger to generate documentation
 - Set up for background job to be created upon creating a store
 - Route for number of items in a store

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
You can pass the query parameter `?&starts_with=mysearch` to search by name (Case sensitive)

- **GET** `/stores` – List all stores
- **GET** `/stores/:id` – Get a specific store
- **GET** `/stores/:id/item_count` – Get a specific store with `item_count` in the response
- **POST** `/stores` – Create a new store
- **PUT** `/stores/:id` – Update a store
- **DELETE** `/stores/:id` – Delete a store

### Items
You can pass the query parameter `?&starts_with=mysearch` to search by name (Case sensitive)

You can also filter by store by using `&store_id=` to find items by a certain store
- **GET** `/items` – List all items
- **GET** `/items/:id` – Get a specific item
- **POST** `/items` – Create a new item (Existing store ID required)
- **PUT** `items/:id` – Update an item
- **DELETE** `/items/:id` – Delete an item

### Ingredients
- **GET** `/ingredients` – List all ingredients
- **GET** `/ingredients/:id` – Get a specific ingredient
- **POST** `/ingredients` – Create a new ingredient (Existing item required)
- **PUT** `/ingredients/:id` – Update an ingredient
- **DELETE** `/ingredients/:id` – Delete an ingredient
