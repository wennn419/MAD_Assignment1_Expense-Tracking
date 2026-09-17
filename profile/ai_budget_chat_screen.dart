import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIBudgetChatScreen extends StatefulWidget {
  const AIBudgetChatScreen({super.key});

  @override
  State<AIBudgetChatScreen> createState() => _AIBudgetChatScreenState();
}

class _AIBudgetChatScreenState extends State<AIBudgetChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [
    {
      'role': 'ai',
      'text': 'Congrats on the freelance payout! Using your adjusted 50/30/20 student budgeting model, here is how you can split your RM 450 earnings:'
    }
  ];
  bool _isLoading = false;

  // Replace with your actual Gemini API Key
  final String _apiKey = 'YOUR_GEMINI_API_KEY_HERE';

  Future<void> _sendMessage() async {
    String text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _isLoading = true;
    });
    _messageController.clear();

    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: _apiKey,
        systemInstruction: Content.system(
          'You are KayaWallet AI assistant for university students. Provide precise split breakdowns for savings, spending, and investing based on user queries.'
        ),
      );

      final response = await model.generateContent([Content.text(text)]);
      
      setState(() {
        _messages.add({
          'role': 'ai',
          'text': response.text ?? 'Here is your budget suggestion.'
        });
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'ai',
          'text': 'AI Error: Please verify your Gemini API key in ai_budget_chat_screen.dart.'
        });
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2C2518)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Ai Advisor', style: TextStyle(color: Color(0xFF2C2518), fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                bool isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFFDCC48C) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text']!,
                          style: const TextStyle(color: Color(0xFF2C2518), fontSize: 13, height: 1.4),
                        ),
                        if (!isUser && index == 0) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: const Color(0xFFFBF8F2), borderRadius: BorderRadius.circular(12)),
                            child: const Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Essential Food & Transit (40%)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    Text('RM 180.00', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('New Laptop Goal (35%)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    Text('RM 157.50', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Emergency Stash (15%)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                    Text('RM 67.50', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(color: Color(0xFF5C5238)),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Ask AI for budgeting advice...',
                      filled: true,
                      fillColor: const Color(0xFFFBF8F2),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.arrow_upward, color: Color(0xFF5C5238)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}