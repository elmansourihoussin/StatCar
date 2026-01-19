# StatCar (Flutter)

StatCar is an offline-first fuel & car cost tracking app tailored to the German
market. The app tracks refuels, calculates consumption and trends, and stores
vehicle expenses with simple analytics.

## Features

- Multi-vehicle support
- Fuel logging with automatic price/liter calculation
- Cost tracking (Kfz-Steuer, Versicherung, HU/AU, Werkstatt, Reifen, etc.)
- KPI dashboard and charts
- CSV export for fuel + costs
- Material 3 light/dark theme
- German (default) with English fallback

## Tech Stack

- Flutter stable + Dart
- Riverpod state management
- SQLite (sqflite) for local storage
- fl_chart for graphs
- share_plus for CSV sharing
- image_picker for receipt photos

## Project Structure

```
lib/
  app.dart
  main.dart
  core/
  data/
  domain/
  presentation/
test/
```

## Setup

```bash
flutter pub get
flutter run
```

## Tests

```bash
flutter test
```

## Notes & Limitations

- CSV import is stubbed and marked TODO.
- Receipt image handling uses the local device file path.
- For advanced analytics, extend `StatsRepository` with more aggregations.
