import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_session_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  void _showAddCardDialog(BuildContext context) {
    final cardNumberController = TextEditingController();
    final expiryController = TextEditingController();
    final cvvController = TextEditingController();
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.addPaymentMethod),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: cardNumberController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.cardNumber,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                maxLength: 16,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: expiryController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.cardDate,
                        hintText: 'MM/YY',
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 5,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: cvvController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.cardCVV,
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      maxLength: 3,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.cardName,
                  border: OutlineInputBorder(),
                ),
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
              if (cardNumberController.text.isNotEmpty &&
                  expiryController.text.isNotEmpty &&
                  cvvController.text.isNotEmpty &&
                  nameController.text.isNotEmpty) {
                final card = {
                  'number': cardNumberController.text,
                  'expiry': expiryController.text,
                  'name': nameController.text,
                };
                context.read<UserSessionProvider>().addPaymentMethod(card.toString());
                Navigator.pop(context);
              }
            },
            child: Text(AppLocalizations.of(context)!.cardAdd),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserSessionProvider>(
      builder: (context, userSession, child) {
        final paymentMethods = userSession.paymentMethods;
        
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.payment),
                  title: Text(AppLocalizations.of(context)!.paymentMethods),
                  trailing: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _showAddCardDialog(context),
                  ),
                ),
                if (paymentMethods.isEmpty)
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      AppLocalizations.of(context)!.noPaymentMethods,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else
                  ...paymentMethods.asMap().entries.map((entry) {
                    final index = entry.key;
                    final method = entry.value;
                    final methodMap = _parseMethodString(method);
                    
                    return Column(
                      children: [
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.credit_card),
                          title: Text('•••• •••• •••• ${methodMap['number']?.substring(methodMap['number']!.length - 4) ?? ''}'),
                          subtitle: Text('${methodMap['expiry']}\n${methodMap['name']}'),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'delete',
                                child: Text(AppLocalizations.of(context)!.delete),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == 'delete') {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(AppLocalizations.of(context)!.deletePaymentMethod),
                                    content: Text(
                                      AppLocalizations.of(context)!.deletePaymentMethodConfirmation,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text(AppLocalizations.of(context)!.cancel),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          userSession.removePaymentMethod(index);
                                          Navigator.pop(context);
                                        },
                                        child: Text(AppLocalizations.of(context)!.delete),
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

  Map<String, String> _parseMethodString(String methodString) {
    // Remove the curly braces and split by commas
    final cleanString = methodString.substring(1, methodString.length - 1);
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