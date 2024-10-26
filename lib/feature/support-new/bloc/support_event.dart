part of 'support_bloc.dart';

sealed class SupportEvent{
  const SupportEvent();
}

class LoadSupportData extends SupportEvent {
  const LoadSupportData();
}
