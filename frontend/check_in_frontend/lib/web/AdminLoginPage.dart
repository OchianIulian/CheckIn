import 'package:flutter/material.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;
  String? error;

  void login() async {
    setState(() {
      loading = true;
      error = null;
    });

    // TODO: call backend -> POST /auth/login
    await Future.delayed(const Duration(seconds: 1));

    setState(() => loading = false);

    // TODO: navigate to WebHomePage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 380,
          child: Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Admin Login',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Parola',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(error!, style: const TextStyle(color: Colors.red)),
                  ],

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: loading ? null : login,
                      child: loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Autentificare'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}