# Awesome Rails Application

Welcome to our awesome Rails application! This README file will guide you through the technical aspects of our project, including dependencies, setup, and how to run the application.

## Prerequisites

Before you begin, ensure you have Ruby version 3.1.2 installed. If not, you can install it using your preferred version manager.

## Getting Started

Follow these simple steps to get the application up and running on your local machine.

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd <repository-directory>
   ```

2. **Install dependencies:**
   ```bash
   bundle install
   ```

3. **Database setup:**
   Make sure you have PostgreSQL installed and running. Create the database and run the migrations:
   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Start the server:**
   ```bash
   rails server -p 5000
   ```

   Your Rails application should now be running at `http://localhost:5000`.

## Dependencies

- **Rails (v7.0.5):** A powerful web application framework written in Ruby.
- **PostgreSQL (v1.1):** A powerful, open-source object-relational database system.
- **Puma (v5.0):** A simple, fast, and highly concurrent HTTP 1.1 server for Ruby/Rack applications.
- **Argon2:** A secure password hashing algorithm.
- **JWT:** JSON Web Tokens for authentication and information exchange.
- **Grover:** Convert html to pdf files.

## Additional Gems

- **Bootsnap:** Reduces boot times through caching.
- **Rack CORS:** Handles Cross-Origin Resource Sharing (CORS) for cross-origin AJAX requests.
- **Rails-i18n:** Provides internationalization (i18n) support for Rails applications.
- **Globalize:** Supports multiple languages in  Rails application.

### Development and Testing Gems

- **RSpec-Rails:** A testing framework for Rails applications.
- **Rswag:** Generates beautiful API documentation for your Rails APIs.

## Acknowledgments

We would like to express our gratitude to the open-source community for their contributions.
