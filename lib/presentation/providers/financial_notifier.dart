import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'user_notifier.dart';
import 'booking_notifier.dart';

part 'financial_notifier.g.dart';

@riverpod
class FinancialStats extends _$FinancialStats {
  @override
  Map<String, dynamic> build() {
    final users = ref.watch(userNotifierProvider).value ?? [];
    final bookings = ref.watch(bookingNotifierProvider).value ?? [];

    // KPI: Total des crédits vendus historiquement
    final totalSales = users.fold<int>(
      0,
      (sum, u) => sum + u.totalCreditsPurchased,
    );

    // KPI: Engagements (Crédits actuellement dans les portfolios)
    final totalEngagement = users.fold<int>(
      0,
      (sum, u) => sum + u.walletBalance,
    );

    // Futur Planning (Prochaines 5 sessions)
    final upcomingSessions =
        bookings.where((b) => b.date.isAfter(DateTime.now())).toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    // Top Clients (Achat cumulé)
    final topClients = [...users]
      ..sort(
        (a, b) => b.totalCreditsPurchased.compareTo(a.totalCreditsPurchased),
      );

    return {
      'totalSales': totalSales,
      'totalEngagement': totalEngagement,
      'upcomingSessions': upcomingSessions.take(5).toList(),
      'topClients': topClients.take(5).toList(),
      'activeStudents': users.length,
    };
  }
}
