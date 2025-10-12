// lib/features/journal/presentation/screens/journal_editor_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/journal_entity.dart';
import '../providers/journal_provider.dart';

class JournalEditorScreen extends ConsumerStatefulWidget {
  final JournalEntity? journal;

  const JournalEditorScreen({super.key, this.journal});

  @override
  ConsumerState<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends ConsumerState<JournalEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final List<String> _tags = [];
  String? _linkedMood;
  bool _isRecording = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.journal?.title ?? '');
    _contentController = TextEditingController(text: widget.journal?.content ?? '');
    if (widget.journal != null) {
      _tags.addAll(widget.journal!.tags);
      _linkedMood = widget.journal!.linkedMood;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveJournal() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both title and content')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final journal = JournalEntity(
        id: widget.journal?.id,
        title: _titleController.text,
        content: _contentController.text,
        timestamp: widget.journal?.timestamp ?? DateTime.now(),
        linkedMood: _linkedMood,
        tags: _tags,
      );

      if (widget.journal == null) {
        await ref.read(journalProvider.notifier).createJournal(journal);
      } else {
        await ref.read(journalProvider.notifier).updateJournal(journal);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.journal == null 
                ? 'Journal entry created!' 
                : 'Journal entry updated!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving journal: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _addTag(String tag) {
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() => _tags.add(tag));
    }
  }

  void _removeTag(String tag) {
    setState(() => _tags.remove(tag));
  }

  void _toggleRecording() {
    setState(() => _isRecording = !_isRecording);
    // TODO: Implement actual audio recording
    if (_isRecording) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio recording started')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio recording stopped')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.journal == null ? 'New Journal Entry' : 'Edit Journal Entry'),
        actions: [
          if (_isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveJournal,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Title',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: 'Write your thoughts...',
                border: OutlineInputBorder(),
              ),
              maxLines: 12,
              minLines: 8,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _toggleRecording,
                    icon: Icon(_isRecording ? Icons.stop : Icons.mic),
                    label: Text(_isRecording ? 'Stop Recording' : 'Record Audio'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _isRecording ? Colors.red : Colors.purple,
                      side: BorderSide(
                        color: _isRecording ? Colors.red : Colors.purple,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('Link to Mood', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Happy', 'Sad', 'Anxious', 'Calm', 'Excited', 'Stressed'].map((mood) {
                final isSelected = _linkedMood == mood;
                return ChoiceChip(
                  label: Text(mood),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() => _linkedMood = selected ? mood : null);
                  },
                  selectedColor: Colors.purple.shade100,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text('Tags', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close, size: 18),
                    onDeleted: () => _removeTag(tag),
                    backgroundColor: Colors.purple.shade50,
                  );
                }),
                ActionChip(
                  label: const Icon(Icons.add, size: 18),
                  onPressed: () => _showAddTagDialog(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTagDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter tag name'),
          autofocus: true,
          onSubmitted: (value) {
            _addTag(value);
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _addTag(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}