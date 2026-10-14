# PointSale

PointSale is a Point of Sale (POS) system consisting of a Flutter frontend and a Laravel backend.

## Project Structure

```text
PointSale/
├── frontend/             # Flutter application
├── backend/              # Laravel API
├── docker-compose.yml/   # Docker-Compose Setup
└── README.md
```

# Setup
## 1. Clone the Project

Clone the project and enter the project directory.

```bash
git clone <repository-url>
cd PointSale-Flutter-Laravel
```

## 2. Backend Environment

Go into the backend directory:

```bash
cd Backend
```

Create the Laravel environment file:

```bash
cp .env.example .env
```

On Windows:

```text
copy .env.example .env
```
or you can just copy `.env.example` manually and rename it to `.env`

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

1. Searh for app app password

2. Enter a name for the app, for example:

   ```text
   PointSale
   ```

4. Click **Create**.

5. Google will generate a **16-character App Password**.

6. Copy this password.

> This 16-character password is what you use for `MAIL_PASSWORD` | Note: Remove Spaces
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

You can then test features that send email, such as password reset or email verification.

> Do not commit `.env` to Git. It may contain database passwords, email credentials, API keys, and other sensitive information.

## 3. Start Docker Compose

From the `Parent` directory run:

```bash
docker compose up -d --build
```

Check that the containers are running:

```bash
docker compose ps
```

This should Start both our frontend & backend container

## 4. Generate Laravel Application Key

This is a fresh installation, generate the Laravel application key for encryption:

```bash
docker compose exec app php artisan key:generate
```

## 5. Run Database Migrations

Run the migrations inside the Laravel container:

```bash
docker compose exec app php artisan migrate
```

## 6. Storage Link

If the application uses Laravel's public storage, create the storage link:

```bash
docker compose exec app php artisan storage:link
```

## Finish

Our Flutter web application should be available at the configured frontend port.\
Example:

```text
http://localhost:8080
```

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
