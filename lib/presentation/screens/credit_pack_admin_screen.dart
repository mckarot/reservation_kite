import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/credit_pack_notifier.dart';
import '../../domain/models/credit_pack.dart';
import 'package:uuid/uuid.dart';

class CreditPackAdminScreen extends ConsumerWidget {
  const CreditPackAdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final packsAsync = ref.watch(creditPackNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Catalogue Forfaits')),
      body: packsAsync.when(
        data: (packs) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: packs.length,
          itemBuilder: (context, index) {
            final pack = packs[index];
            return Card(
              child: ListTile(
                title: Text(
                  pack.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${pack.credits} séances • ${pack.price} €'),
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
        error: (e, _) => Center(child: Text('Erreur: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddPackDialog(context, ref),
        label: const Text('Nouveau Forfait'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPackDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final creditsController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Créer un forfait'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom (ex: Pack 10h)',
              ),
            ),
            TextField(
              controller: creditsController,
              decoration: const InputDecoration(labelText: 'Nombre de crédits'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Prix (€)'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
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
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }
}
