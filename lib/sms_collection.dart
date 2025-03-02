import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'message_detail_screen.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'global_state.dart' as globals;

class SmsCollection extends StatefulWidget {
  const SmsCollection({super.key});

  @override
  State<SmsCollection> createState() => _SmsCollectionState();
}

class _SmsCollectionState extends State<SmsCollection> {
  final SmsQuery _query = SmsQuery();
  Map<String, List<SmsMessage>> _allMessages = {};
  Map<String, List<SmsMessage>> _filteredMessages = {};
  Map<String, List<SmsMessage>> _promotionalMessages = {};
  final Map<String, String> _contactNames = {};
  List<Contact> _contacts = [];

  bool firstTime = true;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchContacts();
    _fetchMessages();
  }

  Future<void> _fetchContacts() async {
    if (globals.GlobalState.userApprovedAddresses.isNotEmpty) {
      firstTime = false;
    }
    Iterable<Contact> contacts =
        await FlutterContacts.getContacts(withProperties: true);
    setState(() {
      _contacts =
          contacts.where((contact) => contact.phones.isNotEmpty).toList();
      for (var contact in _contacts) {
        for (var phone in contact.phones) {
          _contactNames[normalizingPhoneNumber(phone.number)] =
              contact.displayName;
          if (firstTime) {
            globals.GlobalState.addUserApprovedAddress(
                normalizingPhoneNumber(phone.number));
          }
        }
      }
    });
  }

  String normalizingPhoneNumber(String phoneNumber) {
    return phoneNumber
        .replaceAll('+88', '')
        .replaceAll('-', '')
        .replaceAll(' ', '');
  }

  Future<void> _fetchMessages() async {
    List<SmsMessage> messages = await _query.querySms(
      kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
      sort: true, // Sort messages by date
    );
    setState(() {
      _allMessages = _groupMessagesByAddress(messages.toList());
      _filteredMessages = _groupMessagesByAddress(messages
          .where((message) =>
              _isUserApproved(message.address) ||
              _isUserApproved(normalizingPhoneNumber(message.address!)))
          .toList());

      _promotionalMessages = _groupMessagesByAddress(messages
          .where((message) =>
              !_isUserApproved(message.address) &&
              !_isUserApproved(normalizingPhoneNumber(message.address!)))
          .toList());
    });
  }

  Map<String, List<SmsMessage>> _groupMessagesByAddress(
      List<SmsMessage> messages) {
    Map<String, List<SmsMessage>> groupedMessages = {};
    for (var message in messages) {
      if (groupedMessages.containsKey(message.address)) {
        groupedMessages[message.address]!.add(message);
      } else {
        groupedMessages[message.address ?? 'Unknown'] = [message];
      }
    }
    return groupedMessages;
  }

  bool _isUserApproved(String? address) {
    if (address == null) return false;
    // return userApprovedAddresses.contains(address);
    return globals.GlobalState.isUserApproved(address);
  }

  void _togglePromotional(String address) {
    setState(() {
      if (_selectedIndex == 0) {
        if (_isUserApproved(address)) {
          globals.GlobalState.removeUserApprovedAddress(address);
        } else if (_isUserApproved(normalizingPhoneNumber(address))) {
          globals.GlobalState.removeUserApprovedAddress(
              normalizingPhoneNumber(address));
        }
      } else {
        if (!_isUserApproved(address)) {
          globals.GlobalState.addUserApprovedAddress(address);
        }
      }

      _promotionalMessages = _groupMessagesByAddress(
        _allMessages.values
            .expand((messages) => messages)
            .where((message) =>
                !_isUserApproved(message.address) &&
                !_isUserApproved(normalizingPhoneNumber(message.address!)))
            .toList(),
      );

      _filteredMessages = _groupMessagesByAddress(
        _allMessages.values.expand((messages) => messages).where((message) {
          bool isApproved = _isUserApproved(message.address) ||
              _isUserApproved(normalizingPhoneNumber(message.address!));

          return isApproved;
        }).toList(),
      );
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateToMessageDetail(
      BuildContext context, String address, List<SmsMessage> messages) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MessageDetailScreen(address: address, messages: messages),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const SizedBox(width: 15), // Left Padding
            Image.asset(
              'assets/images/test_icon.jpg',
              height: 45,
            ),
            const SizedBox(width: 10), // Padding between images
            Text(
              'বাংলা বার্তা সুরক্ষা অ্যাপ',
              style: TextStyle(
                  color: Colors.blue[100],
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: Colors.blue[500],
      ),
      body: _selectedIndex == 0
          ? RefreshIndicator(
              onRefresh: _fetchMessages,
              child: _buildMessageList(_filteredMessages),
            )
          : RefreshIndicator(
              onRefresh: _fetchMessages,
              child: _buildMessageList(_promotionalMessages),
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.mark_email_read),
            label: 'Approved Contact',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alternate_email),
            label: 'Promotional/Unknown Contact',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[900],
        unselectedItemColor: Colors.grey[700],
        onTap: _onItemTapped,
        backgroundColor: Colors.blue[100],
      ),
      backgroundColor: Colors.blue[300],
    );
  }

  Widget _buildMessageList(Map<String, List<SmsMessage>> messages) {
    List<String> addresses = messages.keys.toList();
    return ListView.builder(
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        if (index >= addresses.length) return const CircularProgressIndicator();

        String address = addresses[index];
        String modifiedAddress =
            _contactNames[normalizingPhoneNumber(address)] ?? address;
        List<SmsMessage> addressMessages = messages[address]!;
        SmsMessage latestMessage = addressMessages.first;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Dismissible(
            key: Key(address),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _togglePromotional(address);
            },
            background: Container(
                color: Colors.red,
                child: const Icon(Icons.swap_horiz, color: Colors.white)),
            child: ListTile(
              leading: Icon(Icons.read_more, color: Colors.blue[800]),
              title: Text(modifiedAddress,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(
                latestMessage.body != null
                    ? (latestMessage.body!.length <= 20
                        ? latestMessage.body!
                        : latestMessage.body!.trim().substring(
                            0, (latestMessage.body!.length ~/ 4).toInt()))
                    : '',
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: Text(
                latestMessage.date != null
                    ? '${latestMessage.date!.day}/${latestMessage.date!.month}/${latestMessage.date!.year}'
                    : '',
                style: const TextStyle(color: Colors.grey),
              ),
              onTap: () => _navigateToMessageDetail(
                  context, modifiedAddress, addressMessages),
            ),
          ),
        );
      },
    );
  }
}
