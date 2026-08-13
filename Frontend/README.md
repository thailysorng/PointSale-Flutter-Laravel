# Point Sale System - Frontend

A modern, visually rich Flutter application for a Point of Sale (POS) system.

## Features

- **Inventory Dashboard**: View and manage product stock levels.
- **Checkout Flow**: Intuitive product selection and cart management.
- **Sales Analytics**: Professional charts and summaries of business performance.
- **Transaction History**: Detailed audit trail of all sales.
- **Responsive Design**: Optimized for multiple platforms (Web, Android, iOS, Windows).

## Tech Stack

- **Framework**: Flutter
- **State Management**: Provider
- **Charts**: fl_chart
- **Formatting**: intl

## Getting Started

### Prerequisites

- Flutter SDK
- Android Studio / VS Code with Flutter extension

### Installation

1.  **Install dependencies**
    ```bash
    flutter pub get
    ```
2.  **Configure API URL**
    The API configuration is located in `lib/core/constants/api_constants.dart`. By default, it uses:
    - `127.0.0.1:8000` for Web and Desktop.
    - `10.0.2.2:8000` for Android Emulator.

3.  **Run the application**
    ```bash
    flutter run
    ```

## Project Structure

- `lib/features/products`: Inventory and product management.
- `lib/features/cart`: Checkout and order processing.
- `lib/features/orders`: Order history.
- `lib/features/transactions`: Financial records.
- `lib/features/analytics`: Performance dashboards and charts.

## License

MIT License
