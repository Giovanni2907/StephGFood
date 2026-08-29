import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:steph_g_food/features/profile/models/user.dart';

class UserNotifier extends StateNotifier<User> {
  UserNotifier()
    : super(
        const User(
          id: '1',
          name: 'Stephanie Giovanni',
          email: 'stephanie@example.com',
          address: '123 Rue de l\'Informatique, Antananarivo',
          complement: 'Appartement 4B',
        ),
      );

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updateAddress(String address, String complement) {
    state = state.copyWith(address: address, complement: complement);
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  return UserNotifier();
});
