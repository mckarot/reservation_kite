import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/service_providers.dart';
import '../../domain/models/user.dart';
import '../../services/weather_service.dart';

class PupilDashboardTab extends StatelessWidget {
  final User user;
  const PupilDashboardTab({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bonjour, ${user.displayName.split(" ")[0]} 🤙',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Prêt pour une session ?',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 24),
          const _CurrentWeatherCard(),
          const SizedBox(height: 32),

          // Card Solde Premium
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade800, Colors.blue.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'MON SOLDE',
                      style: TextStyle(
                        color: Colors.white70,
                        letterSpacing: 1.2,
                        fontSize: 12,
                      ),
                    ),
                    Icon(Icons.waves, color: Colors.white70, size: 20),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${user.walletBalance}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'SEANCES RESTANTES',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          const Text(
            'STATS RAPIDES',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatItem(
                label: 'Niveau IKO',
                value: user.progress?.ikoLevel ?? 'N/A',
                icon: Icons.star,
                color: Colors.amber,
              ),
              const SizedBox(width: 16),
              _StatItem(
                label: 'Progression',
                value:
                    '${user.progress?.checklist.length ?? 0}/${UserProgress.allIkoSkills.length}',
                icon: Icons.flag,
                color: Colors.green,
              ),
            ],
          ),

          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Pensez à prendre votre crème solaire. Rendez-vous au cabanon 15min avant !',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentWeatherCard extends ConsumerWidget {
  const _CurrentWeatherCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherAsync = ref.watch(currentWeatherProvider);
    return weatherAsync.when(
      data: (weather) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Météo Actuelle',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Icon(_getWeatherIcon(weather.weatherCode), color: Colors.blue.shade700, size: 24),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeatherInfoItem(
                  icon: Icons.thermostat,
                  label: '${weather.temperature.round()}°C',
                ),
                _WeatherInfoItem(
                  icon: Icons.air,
                  label: '${weather.windSpeed.round()} km/h',
                ),
                _WeatherInfoItem(
                  icon: Icons.explore,
                  label: _getWindDirection(weather.windDirection),
                ),
              ],
            )
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const SizedBox.shrink(), // Ne rien afficher en cas d'erreur
    );
  }

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

  IconData _getWeatherIcon(int weatherCode) {
    switch (weatherCode) {
      case 0:
        return Icons.wb_sunny;
      case 1:
      case 2:
      case 3:
        return Icons.cloud;
      case 45:
      case 48:
        return Icons.foggy;
      case 51:
      case 53:
      case 55:
        return Icons.grain;
      case 61:
      case 63:
      case 65:
        return Icons.water_drop;
      case 80:
      case 81:
      case 82:
        return Icons.shower;
      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm;
      default:
        return Icons.cloud;
    }
  }
}

class _WeatherInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _WeatherInfoItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade700, size: 28),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}


class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}