import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_constants.dart';

// Chat message model
class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isStreaming;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isStreaming = false,
  });
}

// Chat provider
final chatMessagesProvider = StateNotifierProvider<ChatNotifier, List<ChatMessage>>((ref) {
  return ChatNotifier();
});

class ChatNotifier extends StateNotifier<List<ChatMessage>> {
  ChatNotifier() : super([]);

  void addMessage(ChatMessage message) {
    state = [...state, message];
  }

  void updateLastMessage(String text) {
    if (state.isEmpty) return;
    final messages = [...state];
    final lastMessage = messages.last;
    messages[messages.length - 1] = ChatMessage(
      id: lastMessage.id,
      text: text,
      isUser: lastMessage.isUser,
      timestamp: lastMessage.timestamp,
      isStreaming: true,
    );
    state = messages;
  }

  void finalizeLastMessage() {
    if (state.isEmpty) return;
    final messages = [...state];
    final lastMessage = messages.last;
    messages[messages.length - 1] = ChatMessage(
      id: lastMessage.id,
      text: lastMessage.text,
      isUser: lastMessage.isUser,
      timestamp: lastMessage.timestamp,
      isStreaming: false,
    );
    state = messages;
  }

  void clearMessages() {
    state = [];
  }
}

class AIChatScreen extends ConsumerStatefulWidget {
  final String? initialMessage;

  const AIChatScreen({super.key, this.initialMessage});

  @override
  ConsumerState<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends ConsumerState<AIChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();
  
  bool _isListening = false;
  bool _isSending = false;
  bool _voiceOutputEnabled = false;
  String _language = 'en'; // en or pidgin
  StreamSubscription? _sseSubscription;

  @override
  void initState() {
    super.initState();
    _initializeSpeech();
    _initializeTts();
    
    if (widget.initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _messageController.text = widget.initialMessage!;
        _sendMessage();
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _sseSubscription?.cancel();
    _speech.stop();
    _tts.stop();
    super.dispose();
  }

  Future<void> _initializeSpeech() async {
    await _speech.initialize();
  }

  Future<void> _initializeTts() async {
    await _tts.setLanguage('en-NG'); // Nigerian English
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatMessagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Tutor'),
        actions: [
          // Language Toggle
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            initialValue: _language,
            onSelected: (value) {
              setState(() => _language = value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'en', child: Text('English')),
              const PopupMenuItem(value: 'pidgin', child: Text('Pidgin')),
            ],
          ),
          // Voice Output Toggle
          IconButton(
            icon: Icon(
              _voiceOutputEnabled ? Icons.volume_up : Icons.volume_off,
            ),
            onPressed: () {
              setState(() => _voiceOutputEnabled = !_voiceOutputEnabled);
            },
          ),
          // Clear Chat
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _showClearChatDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Welcome Banner (if no messages)
          if (messages.isEmpty) _buildWelcomeBanner(),

          // Messages List
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return _buildMessageBubble(messages[index])
                          .animate()
                          .fadeIn(delay: (index * 50).ms)
                          .slideY(begin: 0.2, end: 0);
                    },
                  ),
          ),

          // Input Area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.1),
            AppColors.primaryLight.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.psychology,
            size: 48,
            color: AppColors.primary,
          ),
          const SizedBox(height: 12),
          const Text(
            'AI Tutor',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ask me anything about your studies!\nI can explain concepts in ${_language == 'pidgin' ? 'Pidgin' : 'English'}.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              'Start a conversation',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Type a message or use voice input',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser
              ? AppColors.primary
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomRight: message.isUser ? const Radius.circular(4) : null,
            bottomLeft: !message.isUser ? const Radius.circular(4) : null,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                fontSize: 16,
                color: message.isUser
                    ? AppColors.textOnPrimary
                    : AppColors.textPrimary,
              ),
            ),
            if (message.isStreaming)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(
                      message.isUser
                          ? AppColors.textOnPrimary
                          : AppColors.primary,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: message.isUser
                    ? AppColors.textOnPrimary.withOpacity(0.7)
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Voice Input Button
          IconButton(
            icon: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? AppColors.error : AppColors.primary,
            ),
            onPressed: _toggleListening,
          ),

          // Text Input
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask me anything...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),

          const SizedBox(width: 8),

          // Send Button
          IconButton(
            icon: _isSending
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send),
            color: AppColors.primary,
            onPressed: _isSending ? null : _sendMessage,
          ),
        ],
      ),
    );
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await _speech.stop();
      setState(() => _isListening = false);
    } else {
      final available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        await _speech.listen(
          onResult: (result) {
            setState(() {
              _messageController.text = result.recognizedWords;
            });
          },
          localeId: _language == 'pidgin' ? 'en-NG' : 'en-US',
        );
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isSending) return;

    setState(() => _isSending = true);
    _messageController.clear();

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );
    ref.read(chatMessagesProvider.notifier).addMessage(userMessage);

    // Scroll to bottom
    _scrollToBottom();

    try {
      // Add AI message placeholder
      final aiMessageId = '${DateTime.now().millisecondsSinceEpoch}_ai';
      ref.read(chatMessagesProvider.notifier).addMessage(
            ChatMessage(
              id: aiMessageId,
              text: '',
              isUser: false,
              timestamp: DateTime.now(),
              isStreaming: true,
            ),
          );

      // Send to AI with SSE streaming
      await _streamAIResponse(text);

      // Finalize AI message
      ref.read(chatMessagesProvider.notifier).finalizeLastMessage();

      // Speak response if enabled
      if (_voiceOutputEnabled) {
        final messages = ref.read(chatMessagesProvider);
        final lastMessage = messages.last;
        await _tts.speak(lastMessage.text);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  Future<void> _streamAIResponse(String message) async {
    try {
      // TODO: Replace with actual SSE streaming
      // For now, simulate streaming
      final response = _getMockAIResponse(message);
      
      for (int i = 0; i < response.length; i++) {
        await Future.delayed(const Duration(milliseconds: 20));
        ref.read(chatMessagesProvider.notifier).updateLastMessage(
              response.substring(0, i + 1),
            );
        _scrollToBottom();
      }
    } catch (e) {
      rethrow;
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat?'),
        content: const Text('This will delete all messages in this conversation.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(chatMessagesProvider.notifier).clearMessages();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
  }

  String _getMockAIResponse(String message) {
    if (_language == 'pidgin') {
      return 'Oya, make I explain am for you. ${message.toLowerCase().contains('algebra') ? 'Algebra na mathematics wey dey deal with symbols and rules for manipulating those symbols. E dey help us solve problems wey we no fit solve with ordinary arithmetic.' : 'I don hear your question. Make I break am down for you small small so you go understand am well well.'}';
    } else {
      return 'Let me explain that for you. ${message.toLowerCase().contains('algebra') ? 'Algebra is a branch of mathematics that deals with symbols and the rules for manipulating those symbols. It helps us solve problems that cannot be solved with ordinary arithmetic.' : 'I understand your question. Let me break it down step by step so you can understand it clearly.'}';
    }
  }
}
