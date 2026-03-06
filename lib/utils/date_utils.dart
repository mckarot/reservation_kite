/// Formate une date en string ISO-8601 (YYYY-MM-DD) SANS timezone.
///
/// À utiliser pour date_string dans Firestore (equality queries).
/// Conserve la date locale exacte pour éviter les décalages de jour.
String formatDateForQuery(DateTime date) {
  // Utilise les composants de date locaux directement, pas de conversion UTC
  return '${date.year}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}

/// Convertit une date locale en DateTime UTC pour stockage Firestore.
///
/// À utiliser pour date_timestamp dans equipment_rentals.
DateTime toUtcDate(DateTime date) {
  return DateTime.utc(date.year, date.month, date.day);
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

/// Retourne l'heure de début du slot pour une date donnée.
///
/// Slots supportés : 'morning' (08:00), 'afternoon' (13:00), 'full_day' (08:00)
/// Retourne null si le slot n'est pas reconnu.
DateTime? getSlotStartTime(String dateString, String slotName) {
  final date = parseDateFromQuery(dateString);
  
  int hour = 0;
  switch (slotName) {
    case 'morning':
      hour = 8; // 08:00
      break;
    case 'afternoon':
      hour = 13; // 13:00
      break;
    case 'full_day':
      hour = 8; // 08:00
      break;
    default:
      return null;
  }
  
  return DateTime(date.year, date.month, date.day, hour, 0, 0);
}

/// Vérifie si deux dates sont le même jour (même année, mois, jour).
///
/// Utile pour comparer des dates sans tenir compte de l'heure.
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}
