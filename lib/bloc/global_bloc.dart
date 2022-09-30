import 'dart:async';

import 'package:bloc/bloc.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  GlobalBloc() : super(GlobalInitial()) {
    on<GlobalPageChanged>(_onGlobalPageChange);
    on<GlobalPageReloaded>(_onGlobalPageReloaded);
    on<GlobalRequestGoToProfilePage>(_onGlobalUserWantedToLogIn);
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

  FutureOr<void> _onGlobalUserWantedToLogIn(
      GlobalRequestGoToProfilePage event, Emitter<GlobalState> emit) {
    emit(GlobalGoToProfilePage());
  }
}

// Events
abstract class GlobalEvent {}

class GlobalPageChanged extends GlobalEvent {}

class GlobalPageReloaded extends GlobalEvent {}

class GlobalRequestGoToProfilePage extends GlobalEvent {}

// States
abstract class GlobalState {}

class GlobalInitial extends GlobalState {}

class GlobalUpdateData extends GlobalState {}

class GlobalReloadPage extends GlobalState {}

class GlobalGoToProfilePage extends GlobalState {}
