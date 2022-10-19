import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:whatsapp_ui/colors.dart';
import 'package:whatsapp_ui/features/auth/controller/auth_controller.dart';

class OTPScreen extends ConsumerWidget {
  static const String routeName = '/otp-screen';
  final String verificationId;

  const OTPScreen({
    Key? key,
    required this.verificationId,
  }) : super(key: key);

  void verifyOTP(
    WidgetRef ref,
    BuildContext context,
    String userOTP,
  ) {
    ref.read(authControllerProvider).verifyOTP(
          context,
          verificationId,
          userOTP,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifying your number'),
        elevation: 0,
        backgroundColor: backgroundColor,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text('We have sent an SMS with a code.'),
            const SizedBox(
              height: 20,
            ),
            OTPTextField(
              otpFieldStyle: OtpFieldStyle(
                disabledBorderColor: Colors.white,
                enabledBorderColor: Colors.white,
                focusBorderColor: tabColor,
              ),
              length: 6,
              width: size.width * 0.5,
              style: const TextStyle(
                fontSize: 30,
                color: tabColor,
              ),
              onChanged: null,
              onCompleted: (value) {
                print('verifying OTP');
                verifyOTP(ref, context, value);
                print('was running');
              },
            ),
          ],
        ),
      ),
    );
  }
}
