import 'package:check_in_frontend/mobile/MainShellPage.dart';
import 'package:check_in_frontend/mobile/authorization/MemoryTokenStorage.dart';
import 'package:check_in_frontend/utils_mobile/CustomColors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../custom_widgets_mobile//WaveClipper.dart';
import 'auth/AuthApi.dart';
import 'auth/AuthRepository.dart';
import 'authorization/Dio.dart';
import 'authorization/SecureTokenStorage.dart';

class ClientLoginPage extends StatefulWidget {
  const ClientLoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _ClientLoginPageState();
}

class _ClientLoginPageState extends State<ClientLoginPage> {
  late final TokenStore tokenStore;
  late final SecureTokenStorage secureStorage;
  late final Dio dio;
  late final AuthRepository authRepo;

  @override
  void initState() {
    super.initState();
    tokenStore = TokenStore();
    secureStorage = SecureTokenStorage(const FlutterSecureStorage());

    dio = createDioClient(
      baseUrl: 'http://localhost:8080',
      tokenStore: tokenStore,
      secureStorage: secureStorage,
    );

    authRepo = AuthRepository(AuthApi(dio), secureStorage, tokenStore);
  }

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  bool otpSent = false;
  bool loading = false;

  Future<void> requestOtp() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) return;

    debugPrint('requestOtp start mounted=$mounted');
    setState(() => loading = true);

    try {
      await authRepo.requestOtp(phone: phone);
      debugPrint('requestOtp after await mounted=$mounted');

      if (!mounted) return;
      setState(() => otpSent = true);
    } catch (e, st) {
      debugPrint('requestOtp error: $e');
      debugPrintStack(stackTrace: st);
    } finally {
      debugPrint('requestOtp finally mounted=$mounted');
      if (!mounted) return;
      setState(() => loading = false);
    }
  }


  Future<void> verifyOtp() async {
    final phone = phoneController.text.trim();
    final otp = otpController.text.trim();
    if (phone.isEmpty || otp.isEmpty) return;

    setState(() => loading = true);

    var success = false;
    try {
      await authRepo.verifyOtp(phone: phone, otp: otp);
      success = true;
    } catch (e, st) {
      debugPrint('requestOtp error: $e');
      debugPrintStack(stackTrace: st);
    } finally {
      if (!mounted) return;
      setState(() => loading = false);
    }

    if (!mounted) return;
    if (success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShellPage()),
      );
    }
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
                            onPressed: loading ? null : (otpSent ? verifyOtp :  requestOtp),
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



