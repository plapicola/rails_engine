# RailsEngine

RailsEngine implements a versioned JSON API including a set of business intelligence queries based on a suite of CSV files providing a volume of fictitious data for an e-commerce platform. This implementation includes the required files to deploy the application using Docker.

### Dependencies

This project requires the following:

- Docker 18.9
- Docker-Compose 1.23

For non-docker usage:

- Ruby 2.4
- Rails 5.1.6
- PostgreSQL

### Getting Started

##### Using Docker

###### Initial Setup

To build the application using docker, execute the following:

``` bash
docker-compose build
docker-compose up -d
docker-compose exec app rails db:{create,migrate}
docker-compose exec app rake import
```

`build` creates the images and containers required for the application

`up` starts the docker application, with `-d` running the application in a detached state

`exec app rails db:{create,migrate}` creates the database for the application and runs the migrations provided

`exec app rake import` executes a custom rake task to load the information in the provided CSV files located in `/lib/data`

###### Shutting Down the Application

To stop the application, run the following:
``` bash
docker-compose down
```

###### Subsequent Executions

To start the application following initial setup, run the following:
``` bash
docker-compose up -d
```

##### Without Docker

To run the application without using docker, begin by opening `/config/database.yml`. Within this file, comment/remove the existing default database configuration and uncomment the database configuration labeled `# Non-Docker Database Configuration`

After this, execute the following:

``` bash
gem install bundler
bundle install
rails db:{create,migrate}
rake import
```

`bundler` is used to automate dependency requirements for the project

`rails db:{create,migrate}` creates the database and runs the migrations to generate the tables required for this project

`rake import` is a custom task to populate the database with the information within the provided CSV files located in `/lib/data`

###### Starting the Application

To start the application run the following:

```bash
rails s
```

By default, the application listens on port `3000`

###### Stopping the Application

To stop the application when running, press `ctrl + c` to stop the server.

###### Running the Test Suite

The application, when not running in Docker, includes a testing suite built using RSpec. In order to run the test suite, use the command `bundle exec rspec`

### Using the Application

The application provides a uniform collection of API endpoints for all records included in the application. The included record types are:

- Customers
- Merchants
- Items
- Invoices
- Invoice_Items
- Transactions

##### All Records

For each of the record types listed above, the application provides a set of endpoints for retrieving all records. This can be accessed from URLs matching the following pattern:

```
localhost:3000/api/v1/resources
```

Where `resources` is the record type requested.

##### Single Records

For each of the record types, the application also implements an endpoint to retrieve a single record based on the ID of the record. This can be accessed from URLs matching the following pattern:
```
localhost:3000/api/v1/resources/id
```

Where `id` represents the unique ID for a specific resource.

Additionally, the application can return a `random` record from a resource type. This functionality can be accessed from URLs matching the following pattern:

```
localhost:3000/api/v1/resources/random
```

##### Finding Records

The application can find single records based on the information present in the resource. When using this functionality, the application will return the first record found matching the search terms. This functionality can be accessed at URLs matching the following pattern:
```
localhost:3000/api/v1/resources/find?field=value
```

Additionally, the application can find all records for a provided criteria. This functionality can be accessed at URLs matching the following pattern:


```
localhost:3000/api/v1/resources/find_all?field=value
```

The available fields vary for each resource type. A comprehensive list of search fields can be found below, and all matches are `case insensitive`:

Customers:
- id
- first_name
- last_name
- created_at
- updated_at

Merchants:
- id
- name
- created_at
- updated_at

Items:
- id
- name
- description
- unit_price
- merchant_id
- created_at
- updated_at

Invoices:
- id
- customer_id
- merchant_id
- status
- created_at
- updated_at

Transactions:
- id
- credit_card_number
- credit_card_expiration_date
- result
- created_at
- updated_at

Invoice_items:
- id
- item_id
- invoice_id
- unit_price
- quantity
- created_at
- updated_at

##### Resource Relationships

The application also provides a series of endpoints to return the related resources for a given resource. All relationship endpoints can be accessed at URLs matching the following pattern:

```
localhost:3000/api/v1/resources/id/related_resource
```

The available relationships can be found below:

Customers:
- Invoices
- Transactions

Merchants:
- Items
- Invoices

Items:
- Invoice_items
- Merchant

Invoices:
- Transactions
- Invoice_items
- Items
- Customer
- Merchant

Transactions:
- Invoice

Invoice_items:
- Invoice
- Item

##### Business Intelligence

Lastly, the application provides a series of business intelligence endpoints for accessing relevant information regarding the resources present within the system.

###### Information for All Merchants:

The application provides an endpoint to determine the top merchants by revenue, with a quantity flag. This functionality can be accessed from the following endpoint:

```
localhost:3000/api/v1/merchants/most_revenue?quantity=X
```

Additionally, the application provides an endpoint for returning the top merchants by quantity sold, with a quantity flag. This functionality can be accessed at the following URL:

```
localhost:3000/api/v1/merchants/most_items?quantity=X
```

Lastly, the application can return the total revenue for all merchants for a provided date in the form YYYY-MM-DD. To access this functionality, use the following URL:

```
localhost:3000/api/v1/merchants/revenue?date=X
```

###### Information for a Single Merchant

The application provides endpoints for information for single merchants, including the total revenue for all time for a merchant. This functionality can be accessed via the following URL:

```
localhost:3000/api/v1/merchants/id/revenue
```

Additionally, the application can optionally limit the revenue for a single day, passed in the pattern YYYY-MM-DD. This can be accessed using the following URL:

```
localhost:3000/api/v1/merchants/id/revenue?date=X
```

The application can also return the customer who has had the most successful transactions with the merchant. This functionality can be accessed via the following URL:

```
localhost:3000/api/v1/merchants/id/favorite_customer
```

Lastly, the application can return a list of customers who have pending invoices with the merchant. Pending invoices include invoices that have no transactions, or only include transactions where the payment failed. This functionality can be accessed at the following URL:

```
localhost:3000/api/v1/merchants/id/customers_with_pending_invoices
```

###### All Items

The application can return a collection of items ordered by the total revenue generated by the item, with a flag for maximum quantity desired. This functionality can be accessed via the following URL:

```
localhost:3000/api/v1/items/most_revenue?quantity=X
```

Additionally, the application can return a list of items ordered by the total quantity sold, with a flag for quantity desired. This functionality can be accessed using the following URL:

```
localhost:3000/api/v1/items/most_items?quantity=X
```

###### Single Items

The application provides an endpoint for a single item to determine the best day, as quantity sold, for an item. This functionality can be accessed at the following URL:

```
localhost:3000/api/v1/items/id/best_day
```

###### Single Customer

The application can return the merchant who has the most successful transactions with the customer. This functionality can be accessed at the following URL:

```
localhost:3000/api/v1/customers/id/favorite_merchant
```
