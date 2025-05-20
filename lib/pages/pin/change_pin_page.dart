import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pin_provider.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({Key? key}) : super(key: key);

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  final List<String> _currentPin = [];
  final List<String> _newPin = [];
  final List<String> _confirmPin = [];
  int _step = 0; // 0: current, 1: new, 2: confirm
  String _errorMessage = '';

  void _onNumberPressed(String number) {
    if (_errorMessage.isNotEmpty) {
      setState(() {
        _errorMessage = '';
      });
    }

    switch (_step) {
      case 0:
        if (_currentPin.length < 4) {
          setState(() {
            _currentPin.add(number);
          });
          if (_currentPin.length == 4) {
            _verifyCurrentPin();
          }
        }
        break;
      case 1:
        if (_newPin.length < 4) {
          setState(() {
            _newPin.add(number);
          });
          if (_newPin.length == 4) {
            setState(() {
              _step = 2;
            });
          }
        }
        break;
      case 2:
        if (_confirmPin.length < 4) {
          setState(() {
            _confirmPin.add(number);
          });
          if (_confirmPin.length == 4) {
            _verifyNewPins();
          }
        }
        break;
    }
  }

  void _onDeletePressed() {
    switch (_step) {
      case 0:
        if (_currentPin.isNotEmpty) {
          setState(() {
            _currentPin.removeLast();
          });
        }
        break;
      case 1:
        if (_newPin.isNotEmpty) {
          setState(() {
            _newPin.removeLast();
          });
        }
        break;
      case 2:
        if (_confirmPin.isNotEmpty) {
          setState(() {
            _confirmPin.removeLast();
          });
        }
        break;
    }
  }

  Future<void> _verifyCurrentPin() async {
    final isValid = await context.read<PinProvider>().verifyPin(_currentPin.join());
    if (isValid) {
      setState(() {
        _step = 1;
      });
    } else {
      setState(() {
        _errorMessage = 'Invalid current PIN code';
        _currentPin.clear();
      });
    }
  }

  void _verifyNewPins() {
    if (_newPin.join() == _confirmPin.join()) {
      context.read<PinProvider>().setPin(_newPin.join());
      Navigator.pop(context);
    } else {
      setState(() {
        _errorMessage = 'New PIN codes do not match';
        _newPin.clear();
        _confirmPin.clear();
        _step = 1;
      });
    }
  }

  Widget _buildPinDots(List<String> pin) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < pin.length
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300],
          ),
        );
      }),
    );
  }

  Widget _buildNumberButton(String number) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: () => _onNumberPressed(number),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            number,
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  String _getStepTitle() {
    switch (_step) {
      case 0:
        return 'Enter Current PIN';
      case 1:
        return 'Enter New PIN';
      case 2:
        return 'Confirm New PIN';
      default:
        return '';
    }
  }

  List<String> _getCurrentPin() {
    switch (_step) {
      case 0:
        return _currentPin;
      case 1:
        return _newPin;
      case 2:
        return _confirmPin;
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change PIN Code'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Text(
                _getStepTitle(),
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _buildPinDots(_getCurrentPin()),
              if (_errorMessage.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _buildNumberButton('1'),
                        _buildNumberButton('2'),
                        _buildNumberButton('3'),
                      ],
                    ),
                    Row(
                      children: [
                        _buildNumberButton('4'),
                        _buildNumberButton('5'),
                        _buildNumberButton('6'),
                      ],
                    ),
                    Row(
                      children: [
                        _buildNumberButton('7'),
                        _buildNumberButton('8'),
                        _buildNumberButton('9'),
                      ],
                    ),
                    Row(
                      children: [
                        _buildNumberButton('0'),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: ElevatedButton(
                              onPressed: _onDeletePressed,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Icon(Icons.backspace_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
} 