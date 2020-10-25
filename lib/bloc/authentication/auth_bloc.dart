//import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:machine_test/bloc/authentication/auth_event.dart';
//import 'package:machine_test/repository/user_repository.dart';
//
//import 'auth_state.dart';
//
//class AuthBloc extends Bloc<AuthenticationEvent, AuthState> {
//
// UserRepository _userRepository;
//  AuthBloc(): super(null) {
//
//    _userRepository = UserRepository();
//    print('in');
//  }
//
//  @override
//  void onTransition(Transition<AuthenticationEvent, AuthState> transition) {
//    super.onTransition(transition);
//    print(transition);
//  }
//
//
//  @override
//  Stream<AuthState> mapEventToState(AuthenticationEvent event)async* {
//   yield AuthenticatingState();
//
//   if (event is AuthenticationInitialEvent) {
//     yield* _mapAppStartedToState();
//   } else if (event is LoggedIn) {
//     yield* _mapLoggedInToState();
//   } else if (event is LoggedOut) {
//     yield* _mapLoggedOutToState();
//   }
//
//  }
//
//
// Stream<AuthState> _mapAppStartedToState() async* {
//   try {
//     final isSignedIn = await _userRepository.isSignedIn();
//     if (isSignedIn) {
//       final name = await _userRepository.googleSignIn.currentUser.email;
//       yield Authenticated(displayName: name);
//     } else {
//       yield Unauthenticated();
//     }
//   } catch (_) {
//     yield Unauthenticated();
//   }
// }
//
//// Stream<AuthState> _mapLoggedInToState() async* {
////   yield Authenticated(await _userRepository.getUser());
//// }
//
// Stream<AuthState> _mapLoggedOutToState() async* {
//   yield Unauthenticated();
//   _userRepository.signOut();
// }
//}
//}