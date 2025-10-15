import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/journal_entity.dart';
import '../../../../core/services/image_picker_service.dart';

class JournalCardWidget extends StatelessWidget {
  final JournalEntity journal;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onQRCode;

  const JournalCardWidget({
    super.key,
    required this.journal,
    this.onTap,
    this.onDelete,
    this.onQRCode,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: AssetImage('assets/images/journal_card2.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image thumbnail on the left
                if (journal.imageData != null) ...[
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ImagePickerService.imageFromBase64(
                        journal.imageData!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
                
                // Everything else on the right
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title row with action buttons
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              journal.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Action buttons
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (onQRCode != null)
                                IconButton(
                                  icon: const Icon(Icons.qr_code, size: 15),
                                  onPressed: onQRCode,
                                  color: Colors.purple.shade400,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 30,
                                    minHeight: 30,
                                  ),
                                ),
                              if (onQRCode != null) const SizedBox(width: 4),
                              if (onDelete != null)
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 15),
                                  onPressed: onDelete,
                                  color: Colors.red.shade400,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 30,
                                    minHeight: 30,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                      
                      // Description
                      const SizedBox(height: 5),
                      Text(
                        journal.content,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: const Color.fromARGB(255, 48, 46, 46),
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      
                      // Metadata (date, mood, indicators)
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 12,
                        runSpacing: 6,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          // Date
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.calendar_today, size: 10, color: const Color.fromARGB(255, 18, 28, 48)),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat('MMM dd, yyyy').format(journal.timestamp),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: const Color.fromARGB(255, 17, 22, 46),
                                ),
                              ),
                            ],
                          ),
                          
                          // Mood
                          if (journal.linkedMood != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.mood, size: 10, color: const Color.fromARGB(255, 155, 15, 108)),
                                const SizedBox(width: 4),
                                Text(
                                  journal.linkedMood!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: const Color.fromARGB(255, 172, 18, 113)
                                  ),
                                ),
                              ],
                            ),
                          
                          // Audio indicator
                          if (journal.audioPath != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.mic, size: 8, color: Colors.blue.shade600),
                                  const SizedBox(width: 2),
                                  Text(
                                    'Audio',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.blue.shade600,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      
                      // Tags
                      if (journal.tags.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: journal.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 103, 180, 151),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                tag,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: const Color.fromARGB(255, 3, 3, 3),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}