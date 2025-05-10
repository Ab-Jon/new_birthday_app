import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/surprise_message.dart';
import '../service/message_service.dart';

class SurpriseMessagesScreen extends ConsumerWidget {
  const SurpriseMessagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final birthday = DateTime(2025, 5, 6); // set this dynamically if needed
    final now = DateTime.now();
    final remaining = birthday.difference(now);
    final isUnlocked = remaining.isNegative;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Surprise Messages'),
        backgroundColor: Colors.indigo[900],
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.lock, size: 80, color: Colors.indigo),
            const SizedBox(height: 16),
            Text(
              isUnlocked
                  ? '🎉 Surprise Messages Unlocked!'
                  : 'Unlock on Your Birthday!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: 'Comic Sans MS',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            if (!isUnlocked)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.indigo[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${remaining.inDays} days, ${remaining.inHours % 24} hours remaining',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            const SizedBox(height: 20),

            // Messages Section
            Expanded(
              child: ref.watch(surpriseMessagesProvider).when(
                data: (messages) {
                  if (messages.isEmpty) {
                    return const Center(child: Text("No messages yet"));
                  }
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return Card(
                        color: isUnlocked ? Colors.white : Colors.grey[200],
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isUnlocked ? msg.message : 'Hidden Until Birthday',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: isUnlocked ? Colors.black : Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (isUnlocked)
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    '– ${msg.sender}',
                                    style: const TextStyle(fontStyle: FontStyle.italic),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Text("Failed to load messages"),
              ),
            ),

            const SizedBox(height: 10),
            if (!isUnlocked)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  // optional: implement local notification reminder
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  child: Text("Notify Me on Unlock", style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final surpriseMessagesProvider = FutureProvider<List<SurpriseMessage>>((ref) async {
  return fetchSurpriseMessages();
});

