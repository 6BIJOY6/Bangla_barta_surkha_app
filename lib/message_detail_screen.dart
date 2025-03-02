import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'global_state.dart' as globals;

class MessageDetailScreen extends StatefulWidget {
  final String address;
  final List<SmsMessage> messages;

  const MessageDetailScreen({
    required this.address,
    required this.messages,
    super.key,
  });

  @override
  State<MessageDetailScreen> createState() => _MessageDetailScreenState();
}

class _MessageDetailScreenState extends State<MessageDetailScreen> {
  final List<String> _newMessagesList = [];
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _filterAndPredictMessages();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  // Check if text contains Bangla characters
  bool _containsBangla(String text) {
    final banglaRegex = RegExp(r'[\u0980-\u09FF]');
    return banglaRegex.hasMatch(text);
  }

  String extractBangla(String text) {
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    text = text.replaceAll(RegExp(r'[^\u0980-\u09FF\u09E6-\u09EF\s]'), '');
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    return text.trim();
  }

  // Calculate a hash for a given message body
  String _getHash(String text) {
    return md5.convert(utf8.encode(text)).toString();
  }

  // Filter new messages and call API for predictions
  Future<void> _filterAndPredictMessages() async {
    for (SmsMessage message in widget.messages) {
      final body = message.body?.trim() ?? '';
      if (!_containsBangla(body)) {
        continue;
      }

      final modified = extractBangla(body);
      final hash = _getHash(modified);

      if (!globals.GlobalState.predictionsMap.containsKey(hash)) {
        _newMessagesList.add(body);
        if (_newMessagesList.length > 9) {
          await _getBatchPredictions(_newMessagesList);
          _newMessagesList.clear();
        }
      }
    }

    // Fetch predictions from API for new messages
    if (_newMessagesList.isNotEmpty) {
      await _getBatchPredictions(_newMessagesList);
    }
  }

  // API call to get predictions
  Future<void> _getBatchPredictions(List<String> smsList) async {
    final url = Uri.parse(
        "https://bijoy087-bangla-barta-shurkha.hf.space/batch_predict/");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"texts": smsList}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (_isDisposed) return;
      setState(() {
        for (var result in data['results']) {
          final text = result['text'];
          final prediction = result['prediction'];
          final hash = _getHash(extractBangla(text));
          globals.GlobalState.addPrediction(hash, prediction);
        }
      });
    } else {
      if (_isDisposed) return;
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Error"),
            content: const Text(
                "Failed to fetch predictions from the API. Ensure you have an active internet connection."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.address),
        backgroundColor: Colors.blue[400],
      ),
      body: ListView.builder(
        itemCount: widget.messages.length,
        itemBuilder: (context, index) {
          SmsMessage message = widget.messages[index];
          bool isSent = message.kind == SmsMessageKind.sent;
          final body = message.body?.trim() ?? '';

          Color textColor = Colors.black;

          if (_containsBangla(body)) {
            final hash = _getHash(extractBangla(body));
            final prediction =
                globals.GlobalState.predictionsMap[hash] ?? 'Unknown';
            if (prediction == 'Spam') {
              textColor = Colors.red;
            } else if (prediction == 'Ham') {
              textColor = Colors.green;
            }
          } else if (!_containsBangla(body)) {
            textColor = Colors.amber; // No Bangla word
          }

          return Container(
            padding: isSent
                ? const EdgeInsets.only(left: 70, right: 10)
                : const EdgeInsets.only(left: 10, right: 70),
            margin: const EdgeInsets.symmetric(vertical: 8),
            alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
            child: Card(
              color: Colors.grey[100],
              child: ListTile(
                title: Text(
                  body,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                subtitle: Text(
                  message.date != null
                      ? '${message.date!.day}/${message.date!.month}/${message.date!.year}'
                      : '',
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ),
          );
        },
      ),
      backgroundColor: Colors.blue[200],
    );
  }
}
