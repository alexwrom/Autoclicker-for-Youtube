





abstract class AuthRepository{

  Future<void> singInGoogle();
  Future<void> logOut({required bool isDelAcc});
  Future<bool> logIn({required String pass,required String email});
  Future<void> singIn({required String pass,required String email});
  Future<bool> forgotPass({required String email,required String newPass});

}