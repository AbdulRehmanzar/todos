import 'dart:async';


class Injector<T extends StateController> {
 
  static late Injector? injector = Injector();
  static final Map<int, StateController> instances = {};

  T put(T controller) {
    Injector.injector = Injector.injector ?? Injector();
    final exists = instances[controller.runtimeType.hashCode];
    if (exists == null) {
      instances[controller.runtimeType.hashCode] = controller;
      return controller;
    }

    return exists as T;
  }
}


abstract class Streamable<T extends Object?> {
  Stream<T> get stream =>
      throw UnimplementedError("property `stream` doesn't exist");
}


abstract class StateController<S> extends Streamable<S> {

  S _state;

  StreamController<S> controller = StreamController<S>.broadcast();

  StateController(this._state);

  S get state => _state;

  @override
  Stream<S> get stream => controller.stream;

  void emit(S state) {
    _state = state;
    controller.add(state);
  }
}
