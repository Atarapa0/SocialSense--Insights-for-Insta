import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertsProvider extends ChangeNotifier {
  final Set<String> _readAlertIds = {};

  Set<String> get readAlertIds => _readAlertIds;

  AlertsProvider() {
    _loadReadState();
  }

  Future<void> _loadReadState() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? stored = prefs.getStringList('read_alerts');
    if (stored != null) {
      _readAlertIds.addAll(stored);
      notifyListeners();
    }
  }

  Future<void> markAsRead(String alertId) async {
    if (!_readAlertIds.contains(alertId)) {
      _readAlertIds.add(alertId);
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('read_alerts', _readAlertIds.toList());
    }
  }
}
