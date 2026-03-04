import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/models/app_theme_settings.dart';
import '../providers/theme_notifier.dart';

/// Écran de debug pour voir les données brutes Firestore
class FirestoreDebugScreen extends ConsumerStatefulWidget {
  const FirestoreDebugScreen({super.key});

  @override
  ConsumerState<FirestoreDebugScreen> createState() =>
      _FirestoreDebugScreenState();
}

class _FirestoreDebugScreenState extends ConsumerState<FirestoreDebugScreen> {
  List<Map<String, dynamic>> _equipmentData = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadEquipment();
  }

  Future<void> _loadEquipment() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('equipment')
          .limit(10)
          .get();

      setState(() {
        _equipmentData = snapshot.docs.map((doc) {
          return {'id': doc.id, ...doc.data()};
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor =
        themeSettings?.primary ?? AppThemeSettings.defaultPrimary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🔍 Debug Firestore'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEquipment,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Erreur: $_error'))
          : _equipmentData.isEmpty
          ? const Center(child: Text('Aucun équipement trouvé'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _equipmentData.length,
              itemBuilder: (context, index) {
                final item = _equipmentData[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Document ID: ${item['id']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(),
                        ...item.entries.map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${entry.key}:',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _formatValue(entry.value),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  String _formatValue(dynamic value) {
    if (value == null) return 'null';
    if (value is Timestamp) return 'Timestamp: ${value.toDate()}';
    if (value is List) return 'List: ${value.length} items';
    if (value is Map) return 'Map: ${value.length} keys';
    return value.toString();
  }
}
