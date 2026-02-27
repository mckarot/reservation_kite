import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/providers/service_providers.dart';
import '../../services/weather_service.dart';
import '../providers/booking_notifier.dart';
import '../providers/user_notifier.dart';
import '../providers/settings_notifier.dart';
import '../providers/staff_notifier.dart';
import '../providers/unavailability_notifier.dart';
import '../../domain/models/reservation.dart';
import '../../domain/models/staff.dart';
import '../../domain/models/settings.dart' hide TimeSlot;
import '../../domain/models/staff_unavailability.dart';
import '../../domain/logic/booking_validator.dart';
import '../providers/auth_state_provider.dart';

final weatherProvider = StateProvider<AsyncValue<Weather>>((ref) => const AsyncValue.loading());

class PupilBookingScreen extends ConsumerStatefulWidget {
  const PupilBookingScreen({super.key});

  @override
  ConsumerState<PupilBookingScreen> createState() => _PupilBookingScreenState();
}

class _PupilBookingScreenState extends ConsumerState<PupilBookingScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeSlot _selectedSlot = TimeSlot.morning;
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWeatherForSelectedDate();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _fetchWeatherForSelectedDate() async {
    ref.read(weatherProvider.notifier).state = const AsyncValue.loading();
    final today = DateTime.now();
    final difference = _selectedDate.difference(today).inDays;

    if (difference > 14) {
      ref.read(weatherProvider.notifier).state = AsyncValue.error(
        'La date est trop lointaine pour une prévision météo précise.',
        StackTrace.current,
      );
      return;
    }

    try {
      final weatherService = ref.read(weatherServiceProvider);
      final weather = await weatherService.getWeatherForDate(_selectedDate);
      ref.read(weatherProvider.notifier).state = AsyncValue.data(weather);
    } catch (e, s) {
      ref.read(weatherProvider.notifier).state = AsyncValue.error(e, s);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingNotifierProvider);
    final settingsAsync = ref.watch(settingsNotifierProvider);
    final staffAsync = ref.watch(staffNotifierProvider);
    final currentUserAsync = ref.watch(currentUserProvider);
    final unavailabilitiesAsync = ref.watch(unavailabilityNotifierProvider);

    final effectivePupilId = currentUserAsync.value?.id;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Solliciter un cours'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choisissez une date',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(
                            const Duration(days: 90),
                          ),
                        );
                        if (date != null) {
                          setState(() => _selectedDate = date);
                          _fetchWeatherForSelectedDate();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.blue.shade50,
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              DateFormat(
                                'EEEE d MMMM yyyy',
                                'fr_FR',
                              ).format(_selectedDate),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _WeatherInfo(),
                    const SizedBox(height: 32),
                    const Text(
                      'Créneau horaire',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _SlotOption(
                          label: 'Matin',
                          icon: Icons.wb_sunny_outlined,
                          isSelected: _selectedSlot == TimeSlot.morning,
                          onTap: () =>
                              setState(() => _selectedSlot = TimeSlot.morning),
                        ),
                        const SizedBox(width: 16),
                        _SlotOption(
                          label: 'Après-midi',
                          icon: Icons.wb_twilight,
                          isSelected: _selectedSlot == TimeSlot.afternoon,
                          onTap: () => setState(
                            () => _selectedSlot = TimeSlot.afternoon,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Notes ou préférences (optionnel)',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        hintText:
                            'Ex: Préférence pour un moniteur, niveau actuel...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade50,
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(
        context,
        ref,
        bookingsAsync,
        settingsAsync,
        staffAsync,
        unavailabilitiesAsync,
        effectivePupilId,
      ),
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Reservation>> bookingsAsync,
    AsyncValue<SchoolSettings?> settingsAsync,
    AsyncValue<List<Staff>?> staffAsync,
    AsyncValue<List<StaffUnavailability>> unavailabilitiesAsync,
    String? pupilId,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: bookingsAsync.when(
          data: (bookings) {
            final settings = settingsAsync.value;
            final staff = staffAsync.value?.where((s) => s.isActive).toList();

            if (settings == null || staff == null) return const SizedBox();

            final unavailabilities = unavailabilitiesAsync.value ?? [];

            final maxCap = BookingValidator.calculateMaxCapacity(
              activeStaff: staff,
              unavailabilities: unavailabilities,
              settings: settings,
              date: _selectedDate,
              slot: _selectedSlot,
            );
            final currentCount = bookings
                .where(
                  (b) =>
                      b.date.year == _selectedDate.year &&
                      b.date.month == _selectedDate.month &&
                      b.date.day == _selectedDate.day &&
                      b.slot == _selectedSlot &&
                      b.status != ReservationStatus.cancelled,
                )
                .length;

            final remaining = maxCap - currentCount;
            final isFull = remaining <= 0;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isFull ? Icons.block : Icons.check_circle_outline,
                      color: isFull ? Colors.red : Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isFull
                          ? (maxCap == 0
                                ? 'Indisponible (Staff absent)'
                                : 'Complet')
                          : 'Places restantes : $remaining',
                      style: TextStyle(
                        fontSize: 14,
                        color: isFull ? Colors.red : Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: isFull
                        ? null
                        : () => _submitRequest(context, ref, pupilId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Envoyer la demande',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => const SizedBox(),
        ),
      ),
    );
  }

  Future<void> _submitRequest(
    BuildContext context,
    WidgetRef ref,
    String? pupilId,
  ) async {
    if (pupilId == null) return;

    final usersAsync = ref.read(userNotifierProvider);
    final user = usersAsync.value?.firstWhere((u) => u.id == pupilId);

    if (user == null) return;

    if (user.walletBalance <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Solde insuffisant. Veuillez recharger votre compte.'),
        ),
      );
      return;
    }

    final error = await ref
        .read(bookingNotifierProvider.notifier)
        .createBooking(
          clientName: user.displayName,
          date: _selectedDate,
          slot: _selectedSlot,
          pupilId: pupilId,
          status: ReservationStatus.pending,
          notes: _notesController.text,
        );

    if (context.mounted) {
      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Demande envoyée ! En attente de validation admin.'),
          ),
        );
        Navigator.pop(context);
      }
    }
  }
}

class _WeatherInfo extends ConsumerWidget {
  const _WeatherInfo();

  String _getWindDirection(double degrees) {
    if (degrees > 337.5 || degrees <= 22.5) return 'N';
    if (degrees > 22.5 && degrees <= 67.5) return 'NE';
    if (degrees > 67.5 && degrees <= 112.5) return 'E';
    if (degrees > 112.5 && degrees <= 157.5) return 'SE';
    if (degrees > 157.5 && degrees <= 202.5) return 'S';
    if (degrees > 202.5 && degrees <= 247.5) return 'SW';
    if (degrees > 247.5 && degrees <= 292.5) return 'W';
    if (degrees > 292.5 && degrees <= 337.5) return 'NW';
    return '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(weatherProvider);
    return weatherAsync.when(
      data: (weather) => Column(
        children: [
          Card(
            color: Colors.white,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _WeatherItem(icon: _getWeatherIcon(weather.weatherCode), label: '${weather.maxTemperature.round()}°C'),
                  _WeatherItem(icon: Icons.air, label: '${weather.windSpeed.round()} km/h'),
                  _WeatherItem(icon: Icons.explore, label: _getWindDirection(weather.windDirection)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Météo à titre indicatif, susceptible de changer.',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(
        child: Text(
          e is String ? e : 'Erreur météo: ${e.toString()}',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  IconData _getWeatherIcon(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return Icons.wb_sunny; // Ciel clair
      case 1:
      case 2:
      case 3:
        return Icons.cloud; // Partiellement nuageux
      case 45:
      case 48:
        return Icons.foggy; // Brouillard
      case 51:
      case 53:
      case 55:
        return Icons.grain; // Bruine
      case 61:
      case 63:
      case 65:
        return Icons.water_drop; // Pluie
      case 80:
      case 81:
      case 82:
        return Icons.shower; // Averses
      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm; // Orage
      default:
        return Icons.cloud;
    }
  }
}

class _WeatherItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _WeatherItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade700, size: 32),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _SlotOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SlotOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade700 : Colors.white,
            border: Border.all(
              color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade800,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}