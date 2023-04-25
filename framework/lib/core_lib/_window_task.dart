import 'package:flutter/foundation.dart';

abstract class Notifier extends ChangeNotifier {
  ValueListenable<Notifier> listenable() => _Listenable(this);
}


class _Listenable<T extends Notifier>
    extends ValueListenable<T> {
  /// Indicator notifier
  final T _notifier;

  _Listenable(this._notifier);

  final List<VoidCallback> _listeners = [];

  /// Listen for notifications
  void _onNotify() {
    for (final listener in _listeners) {
      listener();
    }
  }

  @override
  void addListener(VoidCallback listener) {
    if (_listeners.isEmpty) {
      _notifier.addListener(_onNotify);
    }
    _listeners.add(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    _listeners.remove(listener);
    if (_listeners.isEmpty) {
      _notifier.removeListener(_onNotify);
    }
  }

  @override
  T get value => _notifier;
}

class WindowTask extends Notifier{

}