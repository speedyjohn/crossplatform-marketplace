import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:market/providers/pin_provider.dart';
import 'package:market/services/pin_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateMocks([PinService, SharedPreferences])
import 'pin_provider_test.mocks.dart';

void main() {
  late MockPinService mockPinService;
  late MockSharedPreferences mockPrefs;
  late PinProvider pinProvider;

  setUp(() {
    mockPinService = MockPinService();
    mockPrefs = MockSharedPreferences();
    pinProvider = PinProvider(mockPinService);
  });

  group('PinProvider Tests', () {
    test('Initial state should not be authenticated', () {
      expect(pinProvider.isAuthenticated, false);
    });

    test('setPin should update pin', () async {
      const testPin = '1234';
      when(mockPinService.setPin(testPin)).thenAnswer((_) async => true);
      
      await pinProvider.setPin(testPin);
      
      verify(mockPinService.setPin(testPin)).called(1);
    });

    test('verifyPin should return true for correct pin', () async {
      const testPin = '1234';
      when(mockPinService.verifyPin(testPin)).thenAnswer((_) async => true);
      
      final result = await pinProvider.verifyPin(testPin);
      
      expect(result, true);
      verify(mockPinService.verifyPin(testPin)).called(1);
    });

    test('verifyPin should return false for incorrect pin', () async {
      const testPin = '1234';
      when(mockPinService.verifyPin(testPin)).thenAnswer((_) async => false);
      
      final result = await pinProvider.verifyPin(testPin);
      
      expect(result, false);
      verify(mockPinService.verifyPin(testPin)).called(1);
    });

    test('hasPin should return true when pin exists', () async {
      when(mockPinService.hasPin()).thenAnswer((_) async => true);
      
      final result = await pinProvider.hasPin();
      
      expect(result, true);
      verify(mockPinService.hasPin()).called(1);
    });
  });
} 