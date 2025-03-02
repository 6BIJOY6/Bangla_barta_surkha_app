import 'package:hive/hive.dart';

class GlobalState {
  //* Predictions Map Box
  static final Box<String> predictionsMapBox =
      Hive.box<String>('predictionsMapBox');

  static Map<String, String> get predictionsMap =>
      Map.from(predictionsMapBox.toMap());

  static void addPrediction(String hash, String prediction) {
    predictionsMapBox.put(hash, prediction);
  }

  //* User Approved Addresses Box
  static final Box<List<String>> userApprovedAddressesBox =
      Hive.box<List<String>>('userApprovedAddressesBox');

  static Set<String> get userApprovedAddresses {
    final List<String>? storedList = userApprovedAddressesBox.get('addresses');
    return storedList != null ? storedList.toSet() : <String>{};
  }

  static void addUserApprovedAddress(String address) {
    final currentAddresses = userApprovedAddresses;
    currentAddresses.add(address);
    userApprovedAddressesBox.put('addresses', currentAddresses.toList());
  }

  static void removeUserApprovedAddress(String address) {
    final currentAddresses = userApprovedAddresses;
    currentAddresses.remove(address);
    userApprovedAddressesBox.put('addresses', currentAddresses.toList());
  }

  static bool isUserApproved(String? address) {
    if (address == null) return false;
    return userApprovedAddresses.contains(address);
  }

  // static final Box<ContactAdapter> contactsBox = Hive.box('contactsBox');
  // static List<ContactAdapter> get contacts => contactsBox.values.toList();
  // static void addContact(ContactAdapter contact) {
  //   contactsBox.add(contact);
  // }
}
