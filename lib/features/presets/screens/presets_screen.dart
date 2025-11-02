import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/presets_provider.dart';
import '../../timer/widgets/quick_start_card.dart';
import '../../timer/providers/timer_controller.dart';

class PresetsScreen extends ConsumerWidget {
  const PresetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presetsAsync = ref.watch(presetsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Presets'),
      ),
      body: presetsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading presets: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(presetsControllerProvider.notifier).loadPresets(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (presets) {
          if (presets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.folder_open, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No presets yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your first custom workout!',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to create preset screen
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Preset'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: presets.length,
            itemBuilder: (context, index) {
              final preset = presets[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: QuickStartCard(
                  preset: preset,
                  onTap: () {
                    ref
                        .read(timerControllerProvider.notifier)
                        .startWithPreset(preset);
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to create preset screen
        },
        icon: const Icon(Icons.add),
        label: const Text('New Preset'),
      ),
    );
  }
}
