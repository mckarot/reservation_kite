import 'package:intl/intl.dart';

/// Formate une date en string ISO-8601 (YYYY-MM-DD) en UTC.
///
/// À utiliser pour toutes les requêtes Firestore sur les dates.
/// Garantit l'absence de décalages de fuseau horaire.
String formatDateForQuery(DateTime date) {
  final utcDate = DateTime.utc(date.year, date.month, date.day);
  return DateFormat('yyyy-MM-dd').format(utcDate);
}

/// Parse un string ISO-8601 en DateTime UTC.
///
/// À utiliser pour convertir les dates stockées en Firestore.
DateTime parseDateFromQuery(String dateString) {
  final parts = dateString.split('-');
  return DateTime.utc(
    int.parse(parts[0]),
    int.parse(parts[1]),
    int.parse(parts[2]),
  );
}

/// Vérifie si deux dates sont le même jour (même année, mois, jour).
///
/// Utile pour comparer des dates sans tenir compte de l'heure.
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
