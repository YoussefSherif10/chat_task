# Chat Application API

## Introduction

This project is a Chat Application API that allows for creating, managing, and searching chats and messages. It uses MySQL as the database and integrates Elasticsearch for enhanced message search functionality. The application is fully dockerized, facilitating easy deployment and scalability.

## API Endpoints

### Applications

1. **Retrieve all applications**
   - **Endpoint:** `GET /v1/applications`
   - **Params:**
     - `page`: (optional) Page number for pagination.
     - `per_page`: (optional) Number of items per page.
   - **Description:** Retrieves a paginated list of all applications.

2. **Create an application**
   - **Endpoint:** `POST /v1/applications`
   - **Params:**
     - `application`: (required) JSON object containing:
       - `name`: (string) Name of the application.
   - **Description:** Creates a new application.

3. **Retrieve an application**
   - **Endpoint:** `GET /v1/applications/{token}`
   - **Params:**
     - `token`: (required) Token of the application.
   - **Description:** Retrieves details of a specific application.

4. **Update an application**
   - **Endpoint:** `PUT /v1/applications/{token}`
   - **Params:**
     - `token`: (required) Token of the application.
     - `application`: (required) JSON object containing:
       - `name`: (string) Updated name of the application.
   - **Description:** Updates an existing application.

5. **Delete an application**
   - **Endpoint:** `DELETE /v1/applications/{token}`
   - **Params:**
     - `token`: (required) Token of the application.
   - **Description:** Deletes an application.

### Chats

1. **Retrieve all chats for an application**
   - **Endpoint:** `GET /v1/applications/{application_token}/chats`
   - **Params:**
     - `application_token`: (required) Token of the application.
     - `page`: (optional) Page number for pagination.
     - `per_page`: (optional) Number of items per page.
   - **Description:** Retrieves a paginated list of all chats for a specific application.

2. **Create a chat**
   - **Endpoint:** `POST /v1/applications/{application_token}/chats`
   - **Params:**
     - `application_token`: (required) Token of the application.
   - **Description:** Creates a new chat for a specific application.

3. **Retrieve a chat**
   - **Endpoint:** `GET /v1/applications/{application_token}/chats/{chat_number}`
   - **Params:**
     - `application_token`: (required) Token of the application.
     - `chat_number`: (required) Number of the chat.
   - **Description:** Retrieves details of a specific chat, including its messages.

4. **Delete a chat**
   - **Endpoint:** `DELETE /v1/applications/{application_token}/chats/{chat_number}`
   - **Params:**
     - `application_token`: (required) Token of the application.
     - `chat_number`: (required) Number of the chat.
   - **Description:** Deletes a specific chat.

### Messages

1. **Retrieve all messages for a chat**
   - **Endpoint:** `GET /v1/applications/{application_token}/chats/{chat_number}/messages`
   - **Params:**
     - `application_token`: (required) Token of the application.
     - `chat_number`: (required) Number of the chat.
     - `page`: (optional) Page number for pagination.
     - `per_page`: (optional) Number of items per page.
   - **Description:** Retrieves a paginated list of all messages for a specific chat.

2. **Create a message**
   - **Endpoint:** `POST /v1/applications/{application_token}/chats/{chat_number}/messages`
   - **Params:**
     - `application_token`: (required) Token of the application.
     - `chat_number`: (required) Number of the chat.
     - `message`: (required) JSON object containing:
       - `content`: (string) Content of the message.
   - **Description:** Creates a new message in a specific chat.

3. **Retrieve a message**
   - **Endpoint:** `GET /v1/applications/{application_token}/chats/{chat_number}/messages/{message_number}`
   - **Params:**
     - `application_token`: (required) Token of the application.
     - `chat_number`: (required) Number of the chat.
     - `message_number`: (required) Number of the message.
   - **Description:** Retrieves details of a specific message.

4. **Update a message**
   - **Endpoint:** `PUT /v1/applications/{application_token}/chats/{chat_number}/messages/{message_number}`
   - **Params:**
     - `application_token`: (required) Token of the application.
     - `chat_number`: (required) Number of the chat.
     - `message_number`: (required) Number of the message.
     - `message`: (required) JSON object containing:
       - `content`: (string) Updated content of the message.
   - **Description:** Updates an existing message.

5. **Delete a message**
   - **Endpoint:** `DELETE /v1/applications/{application_token}/chats/{chat_number}/messages/{message_number}`
   - **Params:**
     - `application_token`: (required) Token of the application.
     - `chat_number`: (required) Number of the chat.
     - `message_number`: (required) Number of the message.
   - **Description:** Deletes a specific message.

## RESTful API

Our API follows RESTful principles, ensuring that the endpoints and HTTP methods align with standard CRUD operations. The primary entities in the project are:

- **Application:** Represents a container for chats.
- **Chat:** Represents a conversation within an application.
- **Message:** Represents an individual message within a chat.

## Database

- I used MySQL as the database management system for storing application, chat, and message data. 
- Necessary indices were created to optimize query performance.

## Enhanced Search with Elasticsearch

Elasticsearch is integrated to enhance searching capabilities within messages. It allows for partial matching on the content of messages, making search operations efficient and effective.

## Scheduled Cron Jobs

I scheduled cron jobs to run every 30 minutes to update the `messages_count` and `chats_count` fields. These jobs:
- Eager load the corresponding associations.
- Access the database in batches for memory optimization.
- Use transactions to avoid race conditions and ensure data integrity.
- Lock rows for update to maintain consistency.

## Pagination with Kaminari

The Kaminari gem is used for pagination, with a configured default setting of 10 items per page. This helps in managing large datasets efficiently.

## Testing with RSpec

Unit tests are written using RSpec to ensure code quality and reliability. These tests cover various aspects of the application, including models, controllers, jobs, and utility modules.

## Dockerized Application

The entire application is fully dockerized for easy deployment. To build and run the application, follow these steps:

1. Create a `.env` file in the root directory with the following content:

    ```
    DEV_DATABASE_NAME=chat-task_dev
    TEST_DATABASE_NAME=chat-task_test
    MYSQL_ROOT_PASSWORD=root
    RAILS_ENV=development
    ELASTIC_HOST=elastic
    ELASTICSEARCH_URL=http://elasticsearch:password@elasticsearch:9200/
    DOMAIN_URL=http://localhost:3000
    REDIS_URL=redis://redis:6379/0
    ```

2. Build and run the Docker containers:

    ```sh
    docker-compose build
    docker-compose up
    ```

This setup ensures that the application and its dependencies are isolated and can be easily managed and scaled.
