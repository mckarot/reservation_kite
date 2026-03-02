import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/credit_pack_notifier.dart';
import '../../domain/models/credit_pack.dart';
import 'package:uuid/uuid.dart';
import '../../domain/models/app_theme_settings.dart';
import '../providers/theme_notifier.dart';
import '../../l10n/app_localizations.dart';

class CreditPackAdminScreen extends ConsumerStatefulWidget {
  const CreditPackAdminScreen({super.key});

  @override
  ConsumerState<CreditPackAdminScreen> createState() => _CreditPackAdminScreenState();
}

class _CreditPackAdminScreenState extends ConsumerState<CreditPackAdminScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final packsAsync = ref.watch(creditPackNotifierProvider);
    
    // Récupérer la couleur principale du thème
    final themeSettingsAsync = ref.watch(themeNotifierProvider);
    final themeSettings = themeSettingsAsync.value;
    final primaryColor = themeSettings?.primary ?? AppThemeSettings.defaultPrimary;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.packCatalogTitle)),
      body: packsAsync.when(
        data: (packs) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: packs.length,
          itemBuilder: (context, index) {
            final pack = packs[index];
            return Card(
              elevation: 2,
              shadowColor: primaryColor.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: primaryColor.withOpacity(0.2), width: 1.5),
              ),
              child: ListTile(
                title: Text(
                  pack.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${pack.credits} ${l10n.sessions} • ${pack.price} €',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => ref
                      .read(creditPackNotifierProvider.notifier)
                      .deletePack(pack.id),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('${l10n.errorLabel}: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPackDialog(context, ref),
        label: Text(l10n.newPack),
        icon: const Icon(Icons.add),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }

  void _showAddPackDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController();
    final creditsController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.createPackTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: l10n.packNameLabel),
            ),
            TextField(
              controller: creditsController,
              decoration: InputDecoration(labelText: l10n.numberOfCredits),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: l10n.priceLabel),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
          ElevatedButton(
            onPressed: () {
              final pack = CreditPack(
                id: const Uuid().v4(),
                name: nameController.text,
                credits: int.parse(creditsController.text),
                price: double.parse(priceController.text),
              );
              ref.read(creditPackNotifierProvider.notifier).addPack(pack);
              Navigator.pop(context);
            },
            child: Text(l10n.createButton),
          ),
        ],
      ),
    );
  }
}
