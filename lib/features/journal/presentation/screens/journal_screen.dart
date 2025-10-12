

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/journal_entity.dart';
import '../providers/journal_provider.dart';
import '../widgets/journal_card_widget.dart';
import '../widgets/qr_code_dialog.dart';
import 'journal_editor_screen.dart';

class JournalScreen extends ConsumerStatefulWidget {
  const JournalScreen({super.key});

  @override
  ConsumerState<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends ConsumerState<JournalScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToEditor([JournalEntity? journal]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalEditorScreen(journal: journal),
      ),
    );
  }

  void _showQRCode(JournalEntity journal) {
    showDialog(
      context: context,
      builder: (context) => QRCodeDialog(journal: journal),
    );
  }

  void _deleteJournal(JournalEntity journal) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Journal Entry'),
        content: Text('Are you sure you want to delete "${journal.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(journalProvider.notifier).deleteJournal(journal.id!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Journal entry deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  List<JournalEntity> _filterJournals(List<JournalEntity> journals) {
    if (_searchQuery.isEmpty) return journals;
    
    final query = _searchQuery.toLowerCase();
    return journals.where((journal) {
      return journal.title.toLowerCase().contains(query) ||
             journal.content.toLowerCase().contains(query) ||
             journal.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }

  Map<String, List<JournalEntity>> _groupJournalsByDate(List<JournalEntity> journals) {
    final grouped = <String, List<JournalEntity>>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final journal in journals) {
      final journalDate = DateTime(
        journal.timestamp.year,
        journal.timestamp.month,
        journal.timestamp.day,
      );

      String key;
      if (journalDate == today) {
        key = 'Today';
      } else if (journalDate == yesterday) {
        key = 'Yesterday';
      } else if (journalDate.isAfter(today.subtract(const Duration(days: 7)))) {
        key = DateFormat('EEEE').format(journalDate);
      } else {
        key = DateFormat('MMMM yyyy').format(journalDate);
      }

      grouped.putIfAbsent(key, () => []).add(journal);
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final journalsAsync = ref.watch(journalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Journal'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: journalsAsync.when(
        data: (journals) {
          final filteredJournals = _filterJournals(journals);
          
          if (filteredJournals.isEmpty) {
            return _buildEmptyState();
          }

          final groupedJournals = _groupJournalsByDate(filteredJournals);

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: groupedJournals.length,
            itemBuilder: (context, index) {
              final dateKey = groupedJournals.keys.elementAt(index);
              final dateJournals = groupedJournals[dateKey]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      dateKey,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade700,
                          ),
                    ),
                  ),
                  ...dateJournals.map((journal) {
                    return JournalCardWidget(
                      journal: journal,
                      onTap: () => _navigateToEditor(journal),
                      onDelete: () => _deleteJournal(journal),
                      onQRCode: () => _showQRCode(journal),
                    );
                  }),
                  const SizedBox(height: 8),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading journals: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.refresh(journalProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToEditor(),
        icon: const Icon(Icons.add),
        label: const Text('New Entry'),
        backgroundColor: Colors.purple,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.book_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              _searchQuery.isEmpty
                  ? 'Start Your Journey'
                  : 'No matching entries',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _searchQuery.isEmpty
                  ? 'Capture your thoughts, feelings, and reflections.\nStart your first journal entry today.'
                  : 'Try a different search term',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => _navigateToEditor(),
                icon: const Icon(Icons.edit),
                label: const Text('Create First Entry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Journals'),
        content: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Enter search term...',
            prefixIcon: Icon(Icons.search),
          ),
          autofocus: true,
          onChanged: (value) {
            setState(() => _searchQuery = value);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}