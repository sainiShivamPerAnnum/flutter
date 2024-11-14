part of 'expert_bloc.dart';

sealed class ExpertDetailsEvent {
  const ExpertDetailsEvent();
}

class LoadExpertsDetails extends ExpertDetailsEvent {
  final String advisorId;
  const LoadExpertsDetails(this.advisorId);
}

class TabChanged extends ExpertDetailsEvent {
  final int tab;
  final String advisorId;
  const TabChanged(this.tab, this.advisorId);
}

class GetCertificate extends ExpertDetailsEvent {
  final String credentialId;
  final String advisorId;
  const GetCertificate(this.credentialId, this.advisorId);
}
