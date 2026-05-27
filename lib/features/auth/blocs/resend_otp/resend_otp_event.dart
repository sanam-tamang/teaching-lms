part of 'resend_otp_bloc.dart';

class ResendOtpEvent extends Equatable {
  const ResendOtpEvent({required this.email});
  final String email;

  @override
  List<Object> get props => [email];
}
