import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_controller.dart';
import 'package:ecommerce_app/src/features/authentication/presentation/sign_in/email_password_sign_in_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../mocks.dart';

void main() {
  const testEmail = 'test@test.com';
  const testPassword = 'test@123';
  group(
    'EmailPasswordSignInController',
    () {
      test(
        '''Given formType is signIn, When signInWithEmailAndPassword succeeds, Then return true and state is AsyncData''',
        () async {
          // setup
          final authRepository = MockAuthRepository();
          when(
            () => authRepository.signInWithEmailAndPassword(
                testEmail, testPassword),
          ).thenAnswer((_) => Future.value());

          final controller = EmailPasswordSignInController(
            formType: EmailPasswordSignInFormType.signIn,
            authRepository: authRepository,
          );

          // run
          final result = await controller.submit(testEmail, testPassword);

          // verify
          expect(result, true);
          expect(
            controller.debugState,
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.signIn,
              value: const AsyncData<void>(null),
            ),
          );
        },
      );
      test(
        '''Given formType is signIn, When signInWithEmailAndPassword fails, Then return false and state is AsyncError''',
        () async {
          // setup
          final authRepository = MockAuthRepository();
          final exception = Exception('Connection failed');
          when(
            () => authRepository.signInWithEmailAndPassword(
                testEmail, testPassword),
          ).thenThrow(exception);

          final controller = EmailPasswordSignInController(
            formType: EmailPasswordSignInFormType.signIn,
            authRepository: authRepository,
          );

          // run
          final result = await controller.submit(testEmail, testPassword);

          // verify
          expect(result, false);
          expect(
            controller.debugState,
            // using predicate since we can't match stack trace
            predicate<EmailPasswordSignInState>((state) {
              expect(state.formType, EmailPasswordSignInFormType.signIn);
              expect(state.value.hasError, true);
              return true;
            }),
          );
        },
      );

      test(
        'Given formType is signIn, When updateFormType with formType as register, Then formType is register',
        () {
          final authRepository = MockAuthRepository();
          final controller = EmailPasswordSignInController(
            formType: EmailPasswordSignInFormType.signIn,
            authRepository: authRepository,
          );
          controller.updateFormType(EmailPasswordSignInFormType.register);
          expect(
            controller.debugState.formType,
            EmailPasswordSignInFormType.register,
          );
        },
      );
      test(
        'Given formType is register, When updateFormType with formType as signIn, Then formType is signIn',
        () {
          final authRepository = MockAuthRepository();
          final controller = EmailPasswordSignInController(
            formType: EmailPasswordSignInFormType.register,
            authRepository: authRepository,
          );
          controller.updateFormType(EmailPasswordSignInFormType.signIn);
          expect(
            controller.debugState.formType,
            EmailPasswordSignInFormType.signIn,
          );
        },
      );
      test(
        '''Given formType is signIn, When createUserWithEmailAndPassword succeeds, Then return true and state is AsyncData''',
        () async {
          // setup
          final authRepository = MockAuthRepository();
          when(
            () => authRepository.createUserWithEmailAndPassword(
                testEmail, testPassword),
          ).thenAnswer((_) => Future.value());

          final controller = EmailPasswordSignInController(
            formType: EmailPasswordSignInFormType.register,
            authRepository: authRepository,
          );

          // run
          final result = await controller.submit(testEmail, testPassword);

          // verify
          expect(result, true);
          expect(
            controller.debugState,
            EmailPasswordSignInState(
              formType: EmailPasswordSignInFormType.register,
              value: const AsyncData<void>(null),
            ),
          );
        },
      );
      test(
        '''Given formType is signIn, When createUserWithEmailAndPassword fails, Then return false and state is AsyncError''',
        () async {
          // setup
          final authRepository = MockAuthRepository();
          final exception = Exception('Connection failed');
          when(
            () => authRepository.createUserWithEmailAndPassword(
                testEmail, testPassword),
          ).thenThrow(exception);

          final controller = EmailPasswordSignInController(
            formType: EmailPasswordSignInFormType.register,
            authRepository: authRepository,
          );

          // run
          final result = await controller.submit(testEmail, testPassword);

          // verify
          expect(result, false);
          expect(
            controller.debugState,
            // using predicate since we can't match stack trace
            predicate<EmailPasswordSignInState>((state) {
              expect(state.formType, EmailPasswordSignInFormType.register);
              expect(state.value.hasError, true);
              return true;
            }),
          );
        },
      );
    },
  );
}
