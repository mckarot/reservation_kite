import 'package:flutter/material.dart';
import '../../domain/models/user.dart';

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
                value: '${user.progress?.checklist.length ?? 0}/8',
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
