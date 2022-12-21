// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list/app/core/exceptions/auth_exceptions.dart';

import './user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({
    required FirebaseAuth firebaseAuth,
  }) : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      var userCredencial = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      return userCredencial.user;
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'email-already-in-use') {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains('password')) {
          throw AuthExceptions(
              message: 'E-mail já utilizado, por favor escolha outro e-mail.');
        } else {
          throw AuthExceptions(
              message:
                  'Você se cadastrou  pelo Google, por favor utilize ele para entrar!');
        }
      } else {
        throw AuthExceptions(message: e.message ?? 'Erro ao registrar usuário');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredentical = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredentical.user;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthExceptions(message: e.message ?? 'Erro ao realizar login.');
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'wrong-password') {
        throw AuthExceptions(message: 'Login ou senha inválidos.');
      }
      throw AuthExceptions(message: e.message ?? 'Erro ao realizar login.');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      var loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);
      if (loginMethods.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginMethods.contains('google')) {
        throw AuthExceptions(
            message:
                'Cadastro realizado com o Google, não pode resetar a senha.');
      } else {
        throw AuthExceptions(message: 'E-mail não encontrado.');
      }
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthExceptions(message: 'Erro ao resetar a senha.');
    }
  }

  @override
  Future<User?> googleLogin() async {
    List<String>? loginMethods;
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        loginMethods =
            await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
        if (loginMethods.contains('password')) {
          throw AuthExceptions(
              message:
                  'Você utilizou o e-mail para cadastro, caso tenha esquecido sua senha clique no link esqueci minha senha.');
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseCredentialProvider = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          var userCredential = await _firebaseAuth
              .signInWithCredential(firebaseCredentialProvider);
          return userCredential.user;
        }
      }
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'account-exists-with-different-credential') {
        throw AuthExceptions(
            message:
                '''Login inválido você se registrou com os seguintes provedores:
          ${loginMethods?.join(',')}
        ''');
      } else {
        throw AuthExceptions(message: 'Erro ao realizar login');
      }
    }
  }

  @override
  Future<User?> logout() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> updateDisplayName(String name) async {
    var user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      user.reload();
    }
  }
}
