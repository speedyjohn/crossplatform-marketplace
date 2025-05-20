import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/pin_provider.dart';

class SetPinPage extends StatefulWidget {
  const SetPinPage({Key? key}) : super(key: key);

  @override
  State<SetPinPage> createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  final List<String> _pin = [];
  final List<String> _confirmPin = [];
  bool _isConfirming = false;
  String _errorMessage = '';

  void _onNumberPressed(String number) {
    if (_errorMessage.isNotEmpty) {
      setState(() {
        _errorMessage = '';
      });
    }

    if (_isConfirming) {
      if (_confirmPin.length < 4) {
        setState(() {
          _confirmPin.add(number);
        });
        if (_confirmPin.length == 4) {
          _verifyPins();
        }
      }
    } else {
      if (_pin.length < 4) {
        setState(() {
          _pin.add(number);
        });
        if (_pin.length == 4) {
          setState(() {
            _isConfirming = true;
          });
        }
      }
    }
  }

  void _onDeletePressed() {
    if (_isConfirming) {
      if (_confirmPin.isNotEmpty) {
        setState(() {
          _confirmPin.removeLast();
        });
      }
    } else {
      if (_pin.isNotEmpty) {
        setState(() {
          _pin.removeLast();
        });
      }
    }
  }

  void _verifyPins() {
    if (_pin.join() == _confirmPin.join()) {
      context.read<PinProvider>().setPin(_pin.join());
    } else {
      setState(() {
        _errorMessage = 'PIN codes do not match';
        _pin.clear();
        _confirmPin.clear();
        _isConfirming = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set PIN Code'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 32),
              Text(
                _isConfirming ? 'Confirm PIN Code' : 'Enter PIN Code',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _buildPinDots(_isConfirming ? _confirmPin : _pin),
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
                        const Spacer(),
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