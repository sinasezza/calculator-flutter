import 'package:flutter/material.dart';

import 'package:calculator/features/calculator/domain/history_entry.dart';

/// End drawer listing past calculations, newest first.
class HistoryDrawer extends StatelessWidget {
  const HistoryDrawer({
    super.key,
    required this.history,
    required this.onClear,
    required this.onSelect,
  });

  final List<HistoryEntry> history;
  final VoidCallback onClear;
  final ValueChanged<HistoryEntry> onSelect;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'History',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (history.isNotEmpty)
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Clear History',
                      onPressed: () {
                        onClear();
                        Navigator.pop(context);
                      },
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: history.isEmpty
                  ? const Center(child: Text('No calculations yet'))
                  : ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final item = history[index];
                        return ListTile(
                          title: Text(
                            item.display,
                            style: const TextStyle(fontSize: 18),
                          ),
                          subtitle: item.time.isNotEmpty
                              ? Text(
                                  item.time,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline,
                                    fontSize: 12,
                                  ),
                                )
                              : null,
                          trailing: const Icon(Icons.north_west, size: 16),
                          onTap: () {
                            onSelect(item);
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
