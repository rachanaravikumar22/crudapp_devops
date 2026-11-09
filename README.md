# Task Manager — Rails CRUD Application

## Overview
This project is a Ruby on Rails rewrite of the original Task Manager application. It provides functionality to create, view, search, edit, and delete tasks using a MySQL database.

## Technologies
- Ruby on Rails
- Ruby
- MySQL
- Puma
- Docker
- Docker Compose
- Kubernetes
- Minikube

## Features
- Create new tasks
- View task history
- Search tasks
- Edit existing tasks
- Delete tasks
- Health-check endpoint at `/up`

## Prerequisites
- Ruby and Bundler
- MySQL
- Docker Desktop
- kubectl and Minikube for Kubernetes deployment

## Run Locally
1. Install the project dependencies:

   ```bash
   bundle install
   ```

2. Configure the database in `config/database.yml`.

3. Create and migrate the database:

   ```bash
   bin/rails db:create db:migrate
   ```

4. Start the Rails server:

   ```bash
   bin/rails server
   ```

5. Open `http://localhost:3000`.

## Project Status
The basic Rails CRUD application and MySQL database setup are implemented. Docker image building, Compose configuration, Kubernetes deployment, and load testing are still being completed.

## Author
Rachana Ravikumar