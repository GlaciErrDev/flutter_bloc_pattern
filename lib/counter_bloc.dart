import 'dart:async';

import './counter_event.dart';

class CounterBloc {
  int _counter = 0;

  final _counterStateController = StreamController<int>();
  // Input is called as Sink
  StreamSink<int> get _inCounter => _counterStateController.sink;
  // For state, exposing only a stream which outputs data
  // Output is called as Stream
  Stream<int> get counter => _counterStateController.stream;

  final _counterEventController = StreamController<CounterEvent>();
  // For event, exposing only a stream which is an input
  Sink<CounterEvent> get counterEventSink => _counterEventController.sink;

  CounterBloc() {
    _counterEventController.stream.listen(_mapEventToState);
  }

  void _mapEventToState(CounterEvent event) {
    if (event is IncrementEvent) {
      _counter++;
    } else if (event is DecrementEvent) {
      _counter--;
    } else if (event is DivideEvent) {
      _counter = (_counter ~/ 2);
    } else if (event is MultiplyEvent) {
      _counter = _counter * 2;
    }

    _inCounter.add(_counter);
  }

  void dispose() {
    _counterEventController.close();
    _counterStateController.close();
  }
}
