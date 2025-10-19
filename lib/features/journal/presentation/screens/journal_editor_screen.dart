import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:serenote/l10n/app_localizations.dart';
import '../../domain/entities/journal_entity.dart';
import '../providers/journal_provider.dart';
import '../../../../core/services/image_picker_service.dart';

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
  bool _isSaving = false;
  String? _existingImageData;

  // Mood colors mapping
  final Map<String, Color> _moodColors = {
    'Happy': const Color(0xFFFFF9C4),
    'Sad': const Color(0xFFE3F2FD),
    'Anxious': const Color(0xFFFFEBEE),
    'Calm': const Color(0xFFE8F5E8),
    'Excited': const Color(0xFFFFF3E0),
    'Stressed': const Color(0xFFF3E5F5),
  };

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.journal?.title ?? '');
    _contentController = TextEditingController(text: widget.journal?.content ?? '');
    if (widget.journal != null) {
      _tags.addAll(widget.journal!.tags);
      _linkedMood = widget.journal!.linkedMood;
      _existingImageData = widget.journal!.imageData;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final l10n = AppLocalizations.of(context);
    try {
      final String? base64Image = await ImagePickerService.pickImage();
      if (base64Image != null && ImagePickerService.isValidBase64(base64Image)) {
        setState(() {
          _existingImageData = base64Image;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.journal_editor_image_added)),
        );
      } else if (base64Image != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.journal_editor_invalid_image)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.journal_editor_image_error}$e')),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _existingImageData = null;
    });
  }

  Future<void> _saveJournal() async {
    final l10n = AppLocalizations.of(context);
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.journal_editor_validation_error)),
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
        imageData: _existingImageData,
      );

      final journalNotifier = ref.read(journalListProvider.notifier);
      if (widget.journal == null) {
        await journalNotifier.createJournal(journal);
      } else {
        await journalNotifier.updateJournal(journal);
      }

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.journal == null
                ? l10n.journal_editor_created
                : l10n.journal_editor_updated),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.journal_editor_save_error}$e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.journal == null
            ? l10n.journal_editor_new_title
            : l10n.journal_editor_edit_title),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sidebar_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80),

              _buildImageSection(l10n),
              const SizedBox(height: 20),

              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: l10n.journal_editor_title_hint,
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: l10n.journal_editor_content_hint,
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                maxLines: 12,
                minLines: 8,
              ),
              const SizedBox(height: 20),

              // Mood selection section
              Text(
                l10n.journal_editor_link_mood,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ['Happy', 'Sad', 'Anxious', 'Calm', 'Excited', 'Stressed']
                    .map((mood) {
                  final isSelected = _linkedMood == mood;
                  final moodColor = _moodColors[mood] ?? Colors.grey.shade100;
                  return GestureDetector(
                    onTap: () {
                      setState(() => _linkedMood = isSelected ? null : mood);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? moodColor.withOpacity(0.8) : moodColor,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color:
                              isSelected ? Colors.purple : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        mood,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Tags section
              Text(
                l10n.journal_editor_tags,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              const SizedBox(height: 12),
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
                      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                    );
                  }),
                  ActionChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add, size: 18),
                        const SizedBox(width: 4),
                        Text(l10n.journal_editor_add_tag),
                      ],
                    ),
                    onPressed: () => _showAddTagDialog(l10n),
                    backgroundColor: Colors.purple.shade100,
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(AppLocalizations l10n) {
    final hasImage = _existingImageData != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.journal_editor_add_image,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
        ),
        const SizedBox(height: 12),
        if (hasImage)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ImagePickerService.imageFromBase64(
                  _existingImageData!,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.close,
                        size: 16, color: Colors.white),
                    onPressed: _removeImage,
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          )
        else
          InkWell(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade50,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate,
                      size: 40, color: Colors.grey.shade500),
                  const SizedBox(height: 8),
                  Text(
                    l10n.journal_editor_add_image,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _showAddTagDialog(AppLocalizations l10n) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.journal_editor_add_tag_dialog),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.journal_editor_tag_hint),
          autofocus: true,
          onSubmitted: (value) {
            _addTag(value);
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.journal_editor_cancel),
          ),
          TextButton(
            onPressed: () {
              _addTag(controller.text);
              Navigator.pop(context);
            },
            child: Text(l10n.journal_editor_add),
          ),
        ],
      ),
    );
  }
}
