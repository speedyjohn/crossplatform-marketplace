import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_session_provider.dart';

class DeliveryAddresses extends StatelessWidget {
  const DeliveryAddresses({Key? key}) : super(key: key);

  void _showAddAddressDialog(BuildContext context) {
    final nameController = TextEditingController();
    final streetController = TextEditingController();
    final cityController = TextEditingController();
    final postalController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Address'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Address Name (e.g. Home, Work)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: streetController,
                decoration: const InputDecoration(
                  labelText: 'Street Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: postalController,
                      decoration: const InputDecoration(
                        labelText: 'Postal Code',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  streetController.text.isNotEmpty &&
                  cityController.text.isNotEmpty &&
                  postalController.text.isNotEmpty) {
                final address = {
                  'name': nameController.text,
                  'street': streetController.text,
                  'city': cityController.text,
                  'postal': postalController.text,
                };
                context.read<UserSessionProvider>().addAddress(address.toString());
                Navigator.pop(context);
              }
            },
            child: const Text('Add Address'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSessionProvider>(
      builder: (context, userSession, child) {
        final addresses = userSession.addresses;
        
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: const Text('Delivery Addresses'),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showAddAddressDialog(context),
                ),
              ),
              if (addresses.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No addresses added yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              else
                ...addresses.asMap().entries.map((entry) {
                  final index = entry.key;
                  final address = entry.value;
                  // Parse the address string back to a map
                  final addressMap = _parseAddressString(address);
                  
                  return Column(
                    children: [
                      const Divider(height: 1),
                      ListTile(
                        title: Text(addressMap['name'] ?? ''),
                        subtitle: Text(
                          '${addressMap['street']}\n${addressMap['city']}, ${addressMap['postal']}',
                        ),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                            const PopupMenuItem(
                              value: 'default',
                              child: Text('Set as Default'),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'delete') {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Address'),
                                  content: const Text(
                                    'Are you sure you want to delete this address?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        userSession.removeAddress(index);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
            ],
          ),
        );
      },
    );
  }

  Map<String, String> _parseAddressString(String addressString) {
    // Remove the curly braces and split by commas
    final cleanString = addressString.substring(1, addressString.length - 1);
    final pairs = cleanString.split(', ');
    
    final Map<String, String> result = {};
    for (final pair in pairs) {
      final parts = pair.split(': ');
      if (parts.length == 2) {
        result[parts[0]] = parts[1];
      }
    }
    
    return result;
  }
} 