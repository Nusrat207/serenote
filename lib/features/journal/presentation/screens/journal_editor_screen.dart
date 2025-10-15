import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  bool _isRecording = false;
  bool _isSaving = false;
  String? _existingImageData;

  // Mood colors mapping
  final Map<String, Color> _moodColors = {
    'Happy': const Color(0xFFFFF9C4), // Light Yellow
    'Sad': const Color(0xFFE3F2FD), // Light Blue
    'Anxious': const Color(0xFFFFEBEE), // Light Red
    'Calm': const Color(0xFFE8F5E8), // Light Green
    'Excited': const Color(0xFFFFF3E0), // Light Orange
    'Stressed': const Color(0xFFF3E5F5), // Light Purple
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
    try {
      final String? base64Image = await ImagePickerService.pickImage();
      
      if (base64Image != null && ImagePickerService.isValidBase64(base64Image)) {
        setState(() {
          _existingImageData = base64Image;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image added successfully!')),
        );
      } else if (base64Image != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid image format')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _removeImage() {
    setState(() {
      _existingImageData = null;
    });
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
            image: AssetImage('assets/images/journal_card2.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 80), // Space for app bar
              
              _buildImageSection(),
              const SizedBox(height: 20),
              
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: 'Write your thoughts...',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
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
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Link to Mood section
              Text(
                'Link to Mood',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: ['Happy', 'Sad', 'Anxious', 'Calm', 'Excited', 'Stressed'].map((mood) {
                  final isSelected = _linkedMood == mood;
                  final moodColor = _moodColors[mood] ?? Colors.grey.shade100;
                  
                  return GestureDetector(
                    onTap: () {
                      setState(() => _linkedMood = isSelected ? null : mood);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected ? moodColor.withOpacity(0.8) : moodColor,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: isSelected ? Colors.purple : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        mood,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.black : Colors.black87,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              
              // Tags section
              Text(
                'Tags',
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
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  }),
                  ActionChip(
                    label: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 18),
                        SizedBox(width: 4),
                        Text('Add Tag'),
                      ],
                    ),
                    onPressed: () => _showAddTagDialog(),
                    backgroundColor: Colors.purple.shade100,
                  ),
                ],
              ),
              const SizedBox(height: 40), // Extra bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    final hasImage = _existingImageData != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Image',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        
        if (hasImage)
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ImagePickerService.imageFromBase64(
                    _existingImageData!,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.close, size: 16, color: Colors.white),
                      onPressed: _removeImage,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
            ),
            child: InkWell(
              onTap: _pickImage,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey.shade500),
                  const SizedBox(height: 8),
                  Text(
                    'Add Image',
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