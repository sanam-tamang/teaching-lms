part of 'resend_otp_bloc.dart';

sealed class ResendOtpState extends Equatable {
  const ResendOtpState();

  @override
  List<Object> get props => [];
}

final class ResendOtpInitial extends ResendOtpState {}

final class ResendOtpLoading extends ResendOtpState {}

final class ResendOtpLoaded extends ResendOtpState {
  final String msg;

  ResendOtpLoaded({required this.msg});
    @override
  List<Object> get props => [msg];
}

final class ResendOtpFailure extends ResendOtpState {
  final String msg;

  ResendOtpFailure({required this.msg});

  @override
  List<Object> get props => [msg];
}
