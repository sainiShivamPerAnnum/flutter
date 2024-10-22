part of 'tell_us_bloc.dart';

sealed class TellUsEvent {
  const TellUsEvent();
}

class SubmitQNA extends TellUsEvent {
  final List<Map<String, String>>  detailsQA;
  final String bookingID;
  const SubmitQNA(this.detailsQA,this.bookingID);
}