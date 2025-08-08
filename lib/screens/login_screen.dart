import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool isRegister = false;
  bool loading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() { loading = true; });
    final auth = ref.read(authServiceProvider);
    try {
      if (isRegister) {
        await auth.signUp(email.trim(), password.trim());
      } else {
        await auth.signIn(email.trim(), password.trim());
      }
      // On success, StreamBuilder in AuthGate will navigate to HomeScreen.
    } catch (e) {
      final snack = SnackBar(content: Text('Auth error: ${e.toString()}'));
      ScaffoldMessenger.of(context).showSnackBar(snack);
    } finally {
      setState(() { loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign in to Radhika Mineral Water')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (v) => email = v ?? '',
                    validator: (v) => (v==null || !v.contains('@')) ? 'Enter valid email' : null,
                  ),
                  SizedBox(height:8),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    onSaved: (v) => password = v ?? '',
                    validator: (v) => (v==null || v.length<6) ? 'Min 6 chars' : null,
                  ),
                  SizedBox(height:12),
                  if (loading) CircularProgressIndicator(),
                  if (!loading) Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submit,
                          child: Text(isRegister ? 'Register' : 'Sign In'),
                        ),
                      ),
                      SizedBox(width:8),
                      TextButton(
                        onPressed: () => setState(() => isRegister = !isRegister),
                        child: Text(isRegister ? 'Have account? Sign In' : 'Register'),
                      )
                    ],
                  )
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
