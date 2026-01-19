import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const _localizedStrings = {
    'de': {
      'appTitle': 'StatCar',
      'onboardingTitle': 'Willkommen',
      'onboardingSubtitle': 'Legen Sie zuerst ein Fahrzeug an.',
      'createVehicle': 'Fahrzeug erstellen',
      'vehicles': 'Fahrzeuge',
      'dashboard': 'Übersicht',
      'fuel': 'Tanken',
      'costs': 'Kosten',
      'stats': 'Statistiken',
      'settings': 'Einstellungen',
      'addFuel': 'Tankfüllung hinzufügen',
      'addCost': 'Kosten hinzufügen',
      'emptyFuel': 'Noch keine Tankfüllungen.',
      'emptyCosts': 'Noch keine Kosten erfasst.',
      'avgConsumption': 'Ø Verbrauch (30T)',
      'avgPrice': 'Ø Preis/L',
      'monthlyCost': 'Monatliche Kosten',
      'save': 'Speichern',
      'cancel': 'Abbrechen',
      'delete': 'Löschen',
      'edit': 'Bearbeiten',
      'date': 'Datum',
      'odometer': 'Kilometerstand',
      'liters': 'Liter',
      'totalCost': 'Gesamtpreis',
      'pricePerLiter': 'Preis/Liter',
      'station': 'Tankstelle',
      'fuelType': 'Kraftstoff',
      'notes': 'Notizen',
      'receiptPhoto': 'Belegfoto',
      'chooseVehicle': 'Fahrzeug wählen',
      'vehicleName': 'Name',
      'brand': 'Marke',
      'model': 'Modell',
      'year': 'Baujahr',
      'defaultFuel': 'Standard-Kraftstoff',
      'costCategory': 'Kategorie',
      'amount': 'Betrag',
      'vendor': 'Anbieter',
      'exportCsv': 'CSV exportieren',
      'importCsv': 'CSV importieren (TODO)',
      'units': 'Einheiten',
      'language': 'Sprache',
      'fullTank': 'Vollgetankt',
      'missedFillUp': 'Zwischenstopp fehlt',
      'duplicateLast': 'Letzten Eintrag duplizieren',
      'noActiveVehicle': 'Kein aktives Fahrzeug.',
    },
    'en': {
      'appTitle': 'StatCar',
      'onboardingTitle': 'Welcome',
      'onboardingSubtitle': 'Create your first vehicle to start.',
      'createVehicle': 'Create vehicle',
      'vehicles': 'Vehicles',
      'dashboard': 'Dashboard',
      'fuel': 'Fuel',
      'costs': 'Costs',
      'stats': 'Stats',
      'settings': 'Settings',
      'addFuel': 'Add fuel entry',
      'addCost': 'Add cost entry',
      'emptyFuel': 'No fuel entries yet.',
      'emptyCosts': 'No costs recorded yet.',
      'avgConsumption': 'Avg consumption (30d)',
      'avgPrice': 'Avg price/L',
      'monthlyCost': 'Monthly costs',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'date': 'Date',
      'odometer': 'Odometer',
      'liters': 'Liters',
      'totalCost': 'Total cost',
      'pricePerLiter': 'Price/L',
      'station': 'Station',
      'fuelType': 'Fuel type',
      'notes': 'Notes',
      'receiptPhoto': 'Receipt photo',
      'chooseVehicle': 'Choose vehicle',
      'vehicleName': 'Name',
      'brand': 'Brand',
      'model': 'Model',
      'year': 'Year',
      'defaultFuel': 'Default fuel',
      'costCategory': 'Category',
      'amount': 'Amount',
      'vendor': 'Vendor',
      'exportCsv': 'Export CSV',
      'importCsv': 'Import CSV (TODO)',
      'units': 'Units',
      'language': 'Language',
      'fullTank': 'Full tank',
      'missedFillUp': 'Missed fill-up',
      'duplicateLast': 'Duplicate last entry',
      'noActiveVehicle': 'No active vehicle.',
    },
  };

  String _t(String key) {
    return _localizedStrings[locale.languageCode]?[key] ??
        _localizedStrings['en']![key]!;
  }

  String get appTitle => _t('appTitle');
  String get onboardingTitle => _t('onboardingTitle');
  String get onboardingSubtitle => _t('onboardingSubtitle');
  String get createVehicle => _t('createVehicle');
  String get vehicles => _t('vehicles');
  String get dashboard => _t('dashboard');
  String get fuel => _t('fuel');
  String get costs => _t('costs');
  String get stats => _t('stats');
  String get settings => _t('settings');
  String get addFuel => _t('addFuel');
  String get addCost => _t('addCost');
  String get emptyFuel => _t('emptyFuel');
  String get emptyCosts => _t('emptyCosts');
  String get avgConsumption => _t('avgConsumption');
  String get avgPrice => _t('avgPrice');
  String get monthlyCost => _t('monthlyCost');
  String get save => _t('save');
  String get cancel => _t('cancel');
  String get delete => _t('delete');
  String get edit => _t('edit');
  String get date => _t('date');
  String get odometer => _t('odometer');
  String get liters => _t('liters');
  String get totalCost => _t('totalCost');
  String get pricePerLiter => _t('pricePerLiter');
  String get station => _t('station');
  String get fuelType => _t('fuelType');
  String get notes => _t('notes');
  String get receiptPhoto => _t('receiptPhoto');
  String get chooseVehicle => _t('chooseVehicle');
  String get vehicleName => _t('vehicleName');
  String get brand => _t('brand');
  String get model => _t('model');
  String get year => _t('year');
  String get defaultFuel => _t('defaultFuel');
  String get costCategory => _t('costCategory');
  String get amount => _t('amount');
  String get vendor => _t('vendor');
  String get exportCsv => _t('exportCsv');
  String get importCsv => _t('importCsv');
  String get units => _t('units');
  String get language => _t('language');
  String get fullTank => _t('fullTank');
  String get missedFillUp => _t('missedFillUp');
  String get duplicateLast => _t('duplicateLast');
  String get noActiveVehicle => _t('noActiveVehicle');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      const ['de', 'en'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
