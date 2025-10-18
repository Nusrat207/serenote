import 'package:flutter/material.dart';
import 'package:serenote/l10n/app_localizations.dart';
class DisplayNameEditor extends StatefulWidget {
  final String? currentName;
  final Function(String) onNameUpdated;

  const DisplayNameEditor({
    super.key,
    this.currentName,
    required this.onNameUpdated,
  });

  @override
  State<DisplayNameEditor> createState() => _DisplayNameEditorState();
}

class _DisplayNameEditorState extends State<DisplayNameEditor> {
  final TextEditingController _nameController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.currentName ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
  loc?.display_name ?? 'Display Name',
  style: const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
        const SizedBox(height: 16),
        _isEditing
            ? Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your display name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _saveName,
                    icon: const Icon(Icons.check, color: Colors.green),
                  ),
                  IconButton(
                    onPressed: _cancelEdit,
                    icon: const Icon(Icons.close, color: Colors.red),
                  ),
                ],
              )
            : Row(
                children: [
                  Text(
                    widget.currentName ?? 'Not set',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _startEditing,
                    icon: const Icon(Icons.edit),
                  ),
                ],
              ),
      ],
    );
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _nameController.text = widget.currentName ?? '';
    });
  }

  void _saveName() {
    if (_nameController.text.trim().isNotEmpty) {
      widget.onNameUpdated(_nameController.text.trim());
      setState(() {
        _isEditing = false;
      });
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      _nameController.text = widget.currentName ?? '';
    });
  }
}