// lib/features/journal/presentation/screens/journal_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
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
            onPressed: () async {
              if (journal.id == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Error: Journal has no ID')),
                );
                Navigator.pop(context);
                return;
              }

              try {
                await ref.read(journalListProvider.notifier).deleteJournal(journal.id!);
                
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Journal entry deleted')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error deleting journal: $e')),
                );
              }
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

  @override
  Widget build(BuildContext context) {
    final journalsAsync = ref.watch(journalListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 216, 240, 245), // Replace with your preferred color
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Colors.black,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 216, 240, 245), // Replace with your preferred color
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search,
                size: 20,
                color: Colors.black,
              ),
            ),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Fixed background image that doesn't scroll
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/journalbg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Scrollable content
          journalsAsync.when(
            data: (journals) {
              final filteredJournals = _filterJournals(journals);
              
              if (filteredJournals.isEmpty) {
                return _buildEmptyState();
              }

              return CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Add some top padding to account for app bar
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 90),
                  ),
                  
                  // Journal content - simple list without day grouping
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final journal = filteredJournals[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: JournalCardWidget(
                            journal: journal,
                            onTap: () => _navigateToEditor(journal),
                            onDelete: () => _deleteJournal(journal),
                            onQRCode: () => _showQRCode(journal),
                          ),
                        );
                      },
                      childCount: filteredJournals.length,
                    ),
                  ),
                  
                  // Add bottom padding for FAB
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 80),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Card(
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error loading journals: $error'),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => ref.refresh(journalListProvider),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToEditor(),
        icon: const Icon(Icons.add),
        label: const Text('New Entry'),
        backgroundColor: Color.fromARGB(255, 216, 240, 245),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Stack(
      children: [
        // Fixed background
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/journalbg.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        
        // Centered empty state content
        Center(
          child: SingleChildScrollView(
            child: Card(
              margin: const EdgeInsets.all(40),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.9),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.book_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _searchQuery.isEmpty
                          ? 'Start Your Journey'
                          : 'No matching entries',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
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
                        color: Colors.grey.shade600,
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
                          backgroundColor: Color.fromARGB(255, 216, 240, 245),
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
            ),
          ),
        ),
      ],
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