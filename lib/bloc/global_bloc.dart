import 'dart:async';

import 'package:bloc/bloc.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(GlobalInitial()) {
    on<GlobalPageChanged>(_onGlobalPageChange);
    on<GlobalPageReloaded>(_onGlobalPageReloaded);
  }

  FutureOr<void> _onGlobalPageChange(
      GlobalPageChanged event, Emitter<GlobalState> emit) {
    emit(GlobalUpdateData());
  }

  FutureOr<void> _onGlobalPageReloaded(
    GlobalPageReloaded event,
    Emitter<GlobalState> emit,
  ) {
    emit(GlobalReloadPage());
  }
}

// Events
abstract class GlobalEvent {}

class GlobalPageChanged extends GlobalEvent {}

class GlobalPageReloaded extends GlobalEvent {}

// States
abstract class GlobalState {}

class GlobalInitial extends GlobalState {}

class GlobalUpdateData extends GlobalState {}

class GlobalReloadPage extends GlobalState {}
