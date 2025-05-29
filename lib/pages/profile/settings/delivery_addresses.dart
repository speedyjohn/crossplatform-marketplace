import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.addAddress),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.nameAddress,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: streetController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.streetAddress,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: cityController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.cityAddress,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: postalController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.postalAddress,
                        border: const OutlineInputBorder(),
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
            child: Text(AppLocalizations.of(context)!.cancel),
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
            child: Text(AppLocalizations.of(context)!.addAddress),
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
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(AppLocalizations.of(context)!.deliveryAddresses),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showAddAddressDialog(context),
                  ),
                ),
                if (addresses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context)!.noAddress,
                      style: const TextStyle(color: Colors.grey),
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
                              PopupMenuItem(
                                value: 'delete',
                                child: Text(AppLocalizations.of(context)!.deleteAddress),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'delete') {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(AppLocalizations.of(context)!.deleteAddress),
                                    content: Text(
                                      AppLocalizations.of(context)!.deleteAddressConfirmation,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(AppLocalizations.of(context)!.cancel),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          userSession.removeAddress(index);
                                          Navigator.pop(context);
                                        },
                                        child: Text(AppLocalizations.of(context)!.deleteAddress),
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