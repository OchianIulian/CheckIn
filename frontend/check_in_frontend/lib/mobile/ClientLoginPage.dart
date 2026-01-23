import 'package:check_in_frontend/mobile/MainShellPage.dart';
import 'package:check_in_frontend/utils_mobile/CustomColors.dart';
import 'package:flutter/material.dart';

import '../custom_widgets_mobile//WaveClipper.dart';
import 'ClientHomePage.dart';

class ClientLoginPage extends StatefulWidget {
  const ClientLoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _ClientLoginPageState();
}

class _ClientLoginPageState extends State<ClientLoginPage> {

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool otpSent = false;
  bool loading = false;

  void requestOtp() {
    setState(() {
      loading = true;
    });

    // Simulate network request
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        otpSent = true;
        loading = false;
      });
    });
  }

  void verifyOtp() async {
    setState(() => loading = true);

    // TODO: call backend -> POST /auth/otp/verify
    await Future.delayed(const Duration(seconds: 1));

    setState(() => loading = false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShellPage()),
    );
    // TODO: navigate to MobileHomePage
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false, // tine background-ul fix
      body: Stack(
        children: [
          // Background wave - NU se misca
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: SizedBox(
                height: 200,
                child: Transform.rotate(
                  angle: 3.14159,
                  child: ClipPath(
                    clipper: WaveClipper(),
                    child: Container(color: CustomColors.greenDark),
                  ),
                ),
              ),
            ),
          ),

          // Continut - se ridica doar cat e tastatura si poate face scroll
          SafeArea(
            child: AnimatedPadding(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(bottom: keyboard),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height
                        - MediaQuery.of(context).padding.top
                        - MediaQuery.of(context).padding.bottom
                        - 48, // aprox SafeArea + padding, ok sa fie simplu
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Autentificare',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 32),

                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Numar de telefon',
                            prefixText: '+40 ',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        if (otpSent) ...[
                          const SizedBox(height: 16),
                          TextField(
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Cod OTP',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: loading ? null : (otpSent ? verifyOtp : requestOtp),
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: CustomColors.greenDark,
                            ),
                            child: loading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(otpSent ? 'Verifica cod' : 'Trimite cod'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



