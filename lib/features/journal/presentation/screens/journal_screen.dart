import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serenote/l10n/app_localizations.dart';
import '../../domain/entities/journal_entity.dart';
import '../providers/journal_provider.dart';
import '../widgets/journal_card_widget.dart';
import '../widgets/qr_code_dialog.dart';
import 'journal_editor_screen.dart';
import 'package:serenote/features/mood/presentation/providers/mood_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../auth/presentation/screens/login_screen.dart';

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

  // ✅ Fixed version of showDialog (use named parameters)
  void _showQRCode(JournalEntity journal) {
    showDialog(
      context: context,
      builder: (context) => QRCodeDialog(journal: journal),
    );
  }

  void _deleteJournal(JournalEntity journal) {
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.journal_delete_title),
        content: Text(l10n.journal_delete_confirm(journal.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.journal_delete_cancel),
          ),
          TextButton(
            onPressed: () async {
              if (journal.id == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.journal_delete_error)),
                );
                Navigator.pop(context);
                return;
              }

              try {
                await ref
                    .read(journalListProvider.notifier)
                    .deleteJournal(journal.id!);

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.journal_delete_success)),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${l10n.journal_error_loading}$e')),
                );
              }
            },
            child: Text(
              l10n.journal_delete_delete,
              style: const TextStyle(color: Colors.red),
            ),
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
    final moodColor = ref.watch(moodColorProvider).maybeWhen(
          data: (c) => c,
          orElse: () => const Color(0xFF477D9E),
        );
    final l10n = AppLocalizations.of(context);

    Color lighten(Color color, [double amount = 0.5]) {
      final hsl = HSLColor.fromColor(color);
      return hsl.withLightness((hsl.lightness + amount).clamp(0, 1)).toColor();
    }

    final lightMood = lighten(moodColor, 0.5);

    final userId = Supabase.instance.client.auth.currentUser;
    final isLoggedIn = userId != null;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [lightMood, Theme.of(context).scaffoldBackgroundColor],
          stops: const [0.0, 0.8],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(l10n.journal_title),
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: moodColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Colors.white,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            if (isLoggedIn)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                margin: const EdgeInsets.only(top: 80),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: l10n.journal_search_hint,
                              border: InputBorder.none,
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.grey),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
                            ),
                            onChanged: (value) {
                              setState(() => _searchQuery = value);
                            },
                          ),
                        ),
                        if (_searchQuery.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                                _searchController.clear();
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
              child: journalsAsync.when(
                data: (journals) {
                  if (!isLoggedIn) {
                    return _buildEmptyState(notLoggedIn: true, l10n: l10n);
                  }

                  final filteredJournals = _filterJournals(journals);

                  if (filteredJournals.isEmpty) {
                    return _buildEmptyState(l10n: l10n);
                  }

                  return CustomScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      const SliverToBoxAdapter(child: SizedBox(height: 10)),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final journal = filteredJournals[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
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
                      const SliverToBoxAdapter(child: SizedBox(height: 80)),
                    ],
                  );
                },
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Card(
                    margin: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text('${l10n.journal_error_loading}$error'),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => ref.refresh(journalListProvider),
                            child: Text(l10n.journal_retry),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: isLoggedIn
            ? FloatingActionButton.extended(
                onPressed: () => _navigateToEditor(),
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  l10n.journal_new_entry,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                backgroundColor: moodColor,
              )
            : null,
      ),
    );
  }

  Widget _buildEmptyState(
      {bool notLoggedIn = false, required AppLocalizations l10n}) {
    return Stack(
      children: [
        Center(
          child: SingleChildScrollView(
            child: Card(
              margin: const EdgeInsets.all(40),
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
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
                      notLoggedIn ? Icons.lock_outline : Icons.book_outlined,
                      size: 80,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      notLoggedIn
                          ? l10n.journal_login_prompt
                          : _searchQuery.isEmpty
                              ? l10n.journal_start_journey
                              : l10n.journal_no_matching,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      notLoggedIn
                          ? l10n.journal_login_description
                          : _searchQuery.isEmpty
                              ? l10n.journal_start_description
                              : l10n.journal_try_different,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    if (notLoggedIn)
                      ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        ),
                        icon: const Icon(Icons.login, color: Colors.black),
                        label: Text(l10n.journal_login_button),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 216, 240, 245),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                    if (!notLoggedIn && _searchQuery.isEmpty) ...[
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () => _navigateToEditor(),
                        icon: const Icon(Icons.edit),
                        label: Text(l10n.journal_create_first),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 216, 240, 245),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
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
}
