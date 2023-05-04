part of 'address_cubit.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressStateInitial extends AddressState {
  const AddressStateInitial();
}

class AddressStateLoading extends AddressState {
  const AddressStateLoading();
}

class AddressStateUpdating extends AddressState {
  const AddressStateUpdating();
}

class AddressStateUpdateError extends AddressState {
  const AddressStateUpdateError(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  List<Object> get props => [message, statusCode];
}

class AddressStateUpdated extends AddressState {
  const AddressStateUpdated(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class AddressStateError extends AddressState {
  final String message;
  final int statusCode;

  const AddressStateError(this.message, this.statusCode);
  @override
  List<Object> get props => [message, statusCode];
}

class AddressStateLoaded extends AddressState {
  final BillingShippingModel address;
  const AddressStateLoaded(this.address);

  @override
  List<Object> get props => [address];
}
