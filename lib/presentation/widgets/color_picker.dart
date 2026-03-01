import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/theme_preset.dart';
import '../../l10n/app_localizations.dart';

/// Widget de sélection des couleurs (presets et custom)
class ColorPicker extends ConsumerWidget {
  final String title;
  final Color selectedColor;
  final Function(Color) onColorSelected;

  const ColorPicker({
    super.key,
    required this.title,
    required this.selectedColor,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        
        // Presets de couleurs
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ThemePreset.all.map((preset) {
            final color = _getColorFromTitle(title, preset);
            final isSelected = color == selectedColor;
            
            return GestureDetector(
              onTap: () => onColorSelected(color),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: isSelected ? 3 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: _getContrastColor(color),
                        size: 24,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
        
        const SizedBox(height: 12),
        
        // Bouton pour couleur personnalisée
        OutlinedButton.icon(
          onPressed: () => _showCustomColorPicker(context, l10n),
          icon: const Icon(Icons.colorize),
          label: Text(l10n.customColor),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Color _getColorFromTitle(String title, ThemePreset preset) {
    if (title.toLowerCase().contains('principal') || title.toLowerCase().contains('primary')) {
      return preset.primaryColor;
    } else if (title.toLowerCase().contains('second')) {
      return preset.secondaryColor;
    } else {
      return preset.accentColor;
    }
  }

  Color _getContrastColor(Color color) {
    // Calculer la luminosité
    final brightness = color.computeLuminance();
    return brightness > 0.5 ? Colors.black : Colors.white;
  }

  void _showCustomColorPicker(BuildContext context, AppLocalizations l10n) async {
    final color = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.customColor),
        content: ColorPickerGrid(
          onColorSelected: (color) => Navigator.pop(context, color),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancelButton),
          ),
        ],
      ),
    );

    if (color != null) {
      onColorSelected(color);
    }
  }
}

/// Grille de couleurs prédéfinies pour le picker custom
class ColorPickerGrid extends StatelessWidget {
  final Function(Color) onColorSelected;

  const ColorPickerGrid({super.key, required this.onColorSelected});

  static const _colors = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
    Colors.black,
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 6,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _colors.length,
        itemBuilder: (context, index) {
          final color = _colors[index];
          return GestureDetector(
            onTap: () => onColorSelected(color),
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
            ),
          );
        },
      ),
    );
  }
}
