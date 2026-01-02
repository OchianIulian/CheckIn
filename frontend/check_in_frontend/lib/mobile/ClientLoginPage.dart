import 'package:check_in_frontend/utils/CustomColors.dart';
import 'package:flutter/material.dart';

import '../custom_widgets/WaveClipper.dart';

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

    // TODO: navigate to MobileHomePage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                    onPressed: loading
                        ? null
                        : otpSent
                        ? verifyOtp
                        : requestOtp,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: CustomColors.greenDark,
                      // foregroundColor: Color(0xFF1E4238),
                      // backgroundColor: Colors.white,
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(otpSent ? 'Verifica cod' : 'Trimite cod'),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              height: 200,
              child: Transform.rotate(
                angle: 3.14159, // wave cu varful in sus
                child: ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    color: CustomColors.greenDark,
                  ),
                ),
              ),
            ),
          ),
        ],
      )


    );
  }
}



