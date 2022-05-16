import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late AccountScreenController controller;
  setUp(() {
    // runs before each test
    authRepository = MockAuthRepository();
    controller = AccountScreenController(authRepository: authRepository);
  });

  group(
    'AccountScreenController',
    () {
      test(
        'Initial state is AsyncValue.data(null)',
        () {
          verifyNever(authRepository.signOut);

          // Use debugState instead of state to use in tests as debugState is explicitly designed to use inside test by riverpod state_notifier
          expect(controller.debugState, const AsyncData<void>(null));
        },
      );

      test('signOut success', () async {
        // setup

        // stubbing signout
        when(() => authRepository.signOut()).thenAnswer((_) => Future.value());

        // run
        await controller.signOut();

        // verify
        verify(authRepository.signOut).called(1);
        expect(controller.debugState, const AsyncData<void>(null));
      });
      test('signOut failure', () async {
        // setup
        final exception = Exception('Connection failed');

        // stubbing signout
        when(() => authRepository.signOut()).thenThrow(exception);

        // run
        await controller.signOut();

        // verify
        verify(authRepository.signOut).called(1);
        // expect(controller.debugState.hasError, true);
        expect(controller.debugState, isA<AsyncError<void>>());
      });
    },
  );
}
