# PointSale

PointSale is a Point of Sale (POS) system consisting of a Flutter frontend and a Laravel backend.

## Project Structure

```text
PointSale/
├── frontend/    # Flutter application
├── backend/     # Laravel API
└── README.md
```

## Requirements

Make sure you have the following installed:

* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
* Git

You do **not** need to install PHP, Composer, MySQL, or Flutter locally if the provided Docker setup is used.

---

# Setup

## 1. Clone the Project

Clone the project and enter the project directory.

```bash
git clone <repository-url>
cd PointSale
```

If the frontend and backend are separate repositories, clone both repositories into the project folder:

```text
PointSale/
├── frontend/
├── backend/
└── README.md
```

---

## 2. Backend Environment

Go into the backend directory:

```bash
cd backend
```

Create the Laravel environment file:

```bash
cp .env.example .env
```

On Windows, you can also copy `.env.example` manually and rename it to:

```text
.env
```

### Configure `.env`

Before starting the application, configure the following values in `.env`.

#### Database

The MySQL password must match the `MYSQL_ROOT_PASSWORD` used by Docker.

```env
DB_CONNECTION=mysql
DB_HOST=mysql_db
DB_PORT=3306
DB_DATABASE=point_sale
DB_USERNAME=user
DB_PASSWORD=your_non_root_user_password

MYSQL_ROOT_PASSWORD=your_mysql_root_password
```

> `MYSQL_ROOT_PASSWORD` is used by the MySQL Docker container to create/configure the root database user.

### Mail Configuration

The application uses email for features such as **email verification** and **password reset**.

This project uses **SMTP** to send emails.

If you are using **Gmail**, you must create a **Google App Password**. Do **not** use your normal Gmail password.

#### 1. Enable 2-Step Verification

Sign in to the Google account that will be used to send emails.

Open your Google Account security settings and enable **2-Step Verification**.

You can access it here:

https://myaccount.google.com/security

Under **How you sign in to Google**, find **2-Step Verification** and complete the setup.

#### 2. Create an App Password

After 2-Step Verification is enabled:

1. Open the **App Passwords** page:

   https://myaccount.google.com/apppasswords

2. Sign in to your Google account if requested.

3. Enter a name for the app, for example:

   ```text
   PointSale
   ```

4. Click **Create**.

5. Google will generate a **16-character App Password**.

6. Copy this password.

> This 16-character password is what you use for `MAIL_PASSWORD`. It is **not your normal Gmail password**.

#### 3. Configure the Backend `.env`

For Gmail, configure the following:

```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-16-character-app-password
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=your-email@gmail.com
MAIL_FROM_NAME="${APP_NAME}"
```

For example:

```env
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=pointofsale@gmail.com
MAIL_PASSWORD=abcdefghijklmnop
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=pointofsale@gmail.com
MAIL_FROM_NAME="${APP_NAME}"
```

Replace:

* `MAIL_USERNAME` → your Gmail address
* `MAIL_PASSWORD` → the **Google App Password** generated in step 2
* `MAIL_FROM_ADDRESS` → the Gmail address that will appear as the sender

#### Important

Do **not** put your normal Gmail password in:

```env
MAIL_PASSWORD=
```

Do not commit the `.env` file to Git because it contains your email credentials and other secrets.

After changing the mail configuration, restart the backend containers:

```bash
docker compose down
docker compose up -d
```

If Laravel is still using old configuration values, clear the cached configuration:

```bash
docker compose exec app php artisan config:clear
```

You can then test features that send email, such as password reset or email verification.

> Do not commit `.env` to Git. It may contain database passwords, email credentials, API keys, and other sensitive information.

## 3. Start the Backend

From the `backend` directory:

```bash
docker compose up -d --build
```

Check that the containers are running:

```bash
docker compose ps
```

The backend should now be available through the configured port.

For example:

```text
http://localhost:8000
```

---

## 4. Generate Laravel Application Key

This is a fresh installation, generate the Laravel application key for encryption:

```bash
docker compose exec app php artisan key:generate
```

---

## 5. Run Database Migrations

Run the migrations inside the Laravel container:

```bash
docker compose exec app php artisan migrate
```

---

## 6. Storage Link

If the application uses Laravel's public storage, create the storage link:

```bash
docker compose exec app php artisan storage:link
```

---

# Frontend Setup

Go to the frontend directory:

```bash
cd ../frontend
```

The Flutter application is also configured to run through Docker.

Then start the frontend using its Docker configuration.

```bash
docker compose up -d --build
```

The Flutter web application should be available at the configured frontend port, Likely:

```text
http://localhost:8080
```

---

# Environment Files

The project uses environment-specific configuration.

Do **not** commit real environment files containing passwords, API keys, or other secrets.

Use the provided example files as templates:

```text
backend/
├── .env.example
└── .env

frontend/
└── ...
```

When setting up the project for the first time:

```text
.env.example → .env
```

Then update the values according to your local Docker configuration.

---

# Useful Docker Commands

### Start containers

```bash
docker compose up -d
```

### Rebuild containers

```bash
docker compose up -d --build
```

### Stop containers

```bash
docker compose down
```

### View running containers

```bash
docker compose ps
```

### View logs

```bash
docker compose logs
```

### View logs for a specific service

```bash
docker compose logs app
```

### Run Laravel Artisan commands

```bash
docker compose exec app php artisan <command>
```

Example:

```bash
docker compose exec app php artisan migrate
```

---

# Development

The project is separated into two parts:

```text
Flutter Frontend
       │
       │ REST API
       ▼
Laravel Backend
       │
       ▼
     MySQL
```

When developing:

* Frontend changes should be made inside `frontend/`.
* Backend changes should be made inside `backend/`.
* Docker handles the required development environments.
* Do not commit `.env` files or other secrets.

## Documentation

* [Frontend README](./frontend/README.md)
* [Backend README](./backend/README.md)
