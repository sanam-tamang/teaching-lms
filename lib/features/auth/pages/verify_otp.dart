import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lms/core/extension/context_extension.dart';
import 'package:lms/core/widgets/primary_btn.dart';
import 'package:lms/features/auth/blocs/resend_otp/resend_otp_bloc.dart';
import 'package:lms/features/auth/verify_otp/verify_otp_bloc.dart';
import 'package:lms/features/home/pages/home.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key, required this.email});

  final String email;

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  int _totalSeconds = 15;
  late int _remainingSeconds = _totalSeconds;

  late Timer _timer;

  void triggerTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (insideTimer) {
      _remainingSeconds = _totalSeconds - insideTimer.tick;
      setState(() {});

      if (_remainingSeconds == 0) {
        insideTimer.cancel();
      }
    });
  }

  @override
  void initState() {
    triggerTimer();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 40),

              Text(
                "Verify Otp",
                style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 40),

              Text("Verify your otp send on ${widget.email}"),

              SizedBox(height: 16),

              Center(
                child: BlocListener<VerifyOtpBloc, VerifyOtpState>(
                  listener: (context, state) {
                    if (state is VerifyOtpLoading) {
                      context.showLoadingDialog();
                    } else if (state is VerifyOtpLoaded) {
                      context.pop();
                      context.showSnackbar("Otp verified");
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => HomePage()),
                        (_) => false,
                      );
                    } else if (state is VerifyOtpFailure) {
                      context.pop();
                      context.showSnackbar(state.msg);
                    }
                  },
                  child: MaterialPinField(
                    length: 6,

                    onCompleted: (pin) {
                      context.read<VerifyOtpBloc>().add(
                        VerifyOtpEvent(email: widget.email, otp: pin),
                      );
                    },

                    theme: MaterialPinTheme(
                      shape: MaterialPinShape.filled,
                      cellSize: Size(50, 60),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24),

              if (_remainingSeconds > 0) Text("Remaining $_remainingSeconds"),

              BlocListener<ResendOtpBloc, ResendOtpState>(
                listener: (context, state) {
                  if (state is ResendOtpLoading) {
                    context.showLoadingDialog();
                  } else if (state is ResendOtpFailure) {
                    context.showSnackbar(state.msg);
                    context.pop();
                  } else if (state is ResendOtpLoaded) {
                    context.showSnackbar(state.msg);
                    context.pop();
                  }
                },
                child: PrimaryBtn(
                  onPressed: _remainingSeconds > 0
                      ? null
                      : () {
                          context.read<ResendOtpBloc>().add(
                            ResendOtpEvent(email: widget.email),
                          );
                          triggerTimer();
                        },
                  child: Text("Resend otp"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
