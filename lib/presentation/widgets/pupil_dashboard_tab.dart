import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers/service_providers.dart';
import '../../domain/models/user.dart';
import '../../domain/models/app_theme_settings.dart';
import '../providers/theme_notifier.dart';
import '../../l10n/app_localizations.dart';

class PupilDashboardTab extends ConsumerWidget {
  final User user;
  const PupilDashboardTab({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    
    // Récupérer la couleur principale du thème
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor = themeSettings?.primary ?? AppThemeSettings.defaultPrimary;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${l10n.welcomeMessage(user.displayName.split(" ")[0])} 🤙',
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.readyForSession,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 24),
          const _CurrentWeatherCard(),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: primaryColor.withOpacity(0.3), width: 1.5),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: primaryColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    l10n.weatherInfo,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Card Solde Premium
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryColor.withOpacity(0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: primaryColor.withOpacity(0.3), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      l10n.myBalance,
                      style: const TextStyle(
                        color: Colors.white70,
                        letterSpacing: 1.2,
                        fontSize: 12,
                      ),
                    ),
                    const Icon(Icons.waves, color: Colors.white70, size: 20),
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
                Text(
                  l10n.sessionsRemaining,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
          Text(
            l10n.quickStats,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _StatItem(
                label: l10n.ikoLevel,
                value: user.progress?.ikoLevel ?? l10n.notAvailable,
                icon: Icons.star,
                color: Colors.amber,
              ),
              const SizedBox(width: 16),
              _StatItem(
                label: l10n.progression,
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
              gradient: LinearGradient(
                colors: [Colors.orange.shade50, Colors.amber.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.withOpacity(0.3), width: 1.5),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.sunny_snowing,
                  color: Colors.orange.shade700,
                  size: 32,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.sunSafetyReminder,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.sunSafetyTip,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.orange,
                        ),
                      ),
                    ],
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
    final l10n = AppLocalizations.of(context);
    final weatherAsync = ref.watch(currentWeatherProvider);
    
    // Récupérer la couleur principale du thème
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor = themeSettings?.primary ?? AppThemeSettings.defaultPrimary;
    
    return weatherAsync.when(
      data: (weather) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: primaryColor.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.currentWeather,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Icon(
                  _getWeatherIcon(weather.weatherCode),
                  color: primaryColor,
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeatherInfoItem(
                  icon: Icons.thermostat,
                  label: '${weather.temperature.round()}°C',
                  color: primaryColor,
                ),
                _WeatherInfoItem(
                  icon: Icons.air,
                  label: '${(weather.windSpeed / 1.852).round()} ${l10n.knots}',
                  color: primaryColor,
                ),
                _WeatherInfoItem(
                  icon: Icons.explore,
                  label: _getWindDirection(weather.windDirection),
                  color: primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => const SizedBox.shrink(),
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
  final Color? color;

  const _WeatherInfoItem({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.blue.shade700, size: 28),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
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

  String _getTranslatedIkoLevel(BuildContext context, String level) {
    final l10n = AppLocalizations.of(context);
    // Mapping des niveaux IKO vers les traductions
    switch (level) {
      case 'Niveau 1 - Découverte':
      case 'Niveau 1':
        return l10n.ikoLevel1Discovery;
      case 'Niveau 2 - Intermédiaire':
      case 'Niveau 2':
        return l10n.ikoLevel2Intermediate;
      case 'Niveau 3 - Indépendant':
      case 'Niveau 3':
        return l10n.ikoLevel3Independent;
      case 'Niveau 4 - Perfectionnement':
      case 'Niveau 4':
        return l10n.ikoLevel4Advanced;
      default:
        return level;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              _getTranslatedIkoLevel(context, value),
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
