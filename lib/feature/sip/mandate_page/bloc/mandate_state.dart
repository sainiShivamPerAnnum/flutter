part of 'mandate_bloc.dart';

sealed class SubsTransactionStatus {
  const SubsTransactionStatus();
  const factory SubsTransactionStatus.ideal() = Ideal;
  const factory SubsTransactionStatus.creating() = Creating;
  const factory SubsTransactionStatus.created({
    required String subsPrimaryKey,
    required String redirectUrl,
    required bool mandateAlreadyExits,
    SubscriptionStatusData? subscriptionData,
  }) = Created;
  const factory SubsTransactionStatus.failed(String message) = Failed;
}

class Ideal extends SubsTransactionStatus {
  const Ideal();
}

class Creating extends SubsTransactionStatus {
  const Creating();
}

class Created extends SubsTransactionStatus {
  final String subsPrimaryKey;
  final String redirectUrl;
  final bool mandateAlreadyExits;
  final SubscriptionStatusData? subscriptionData;

  const Created({
    required this.subsPrimaryKey,
    required this.redirectUrl,
    this.mandateAlreadyExits = false,
    this.subscriptionData,
  });
}

class Failed extends SubsTransactionStatus {
  const Failed(this.message);
  final String message;
}

sealed class MandateState extends Equatable {
  const MandateState();

  @override
  List<Object?> get props => const [];
}

class MandateInitialState extends MandateState {
  const MandateInitialState();

  @override
  List<Object?> get props => const [];
}

class ListingPSPApps extends MandateState {
  const ListingPSPApps();

  @override
  List<Object?> get props => const [];
}

class ListedPSPApps extends MandateState {
  final List<ApplicationMeta> pspApps;
  final SubsTransactionStatus transactionStatus;
  final bool isTransactionInProgress;
  final String? subsTransactionKey; // the primary key for subscription.

  const ListedPSPApps(
    this.pspApps, {
    this.transactionStatus = const Ideal(),
    this.subsTransactionKey,
    this.isTransactionInProgress = false,
  });

  ListedPSPApps copyWith({
    SubsTransactionStatus? status,
    bool? isTransactionInProgress,
  }) {
    return ListedPSPApps(
      pspApps,
      transactionStatus: status ?? transactionStatus,
      isTransactionInProgress:
          isTransactionInProgress ?? this.isTransactionInProgress,
      subsTransactionKey: subsTransactionKey,
    );
  }

  @override
  List<Object?> get props => [
        pspApps,
        transactionStatus,
        subsTransactionKey,
        isTransactionInProgress,
      ];
}
