import 'package:flutter/material.dart';

/// Shared geographic context for the entire campaign application.
///
/// A selection made in Benue Map becomes the active scope for operational
/// modules. Ward and polling-unit support is already represented here, but
/// those levels should only be selected after verified geography imports.
class CampaignScopeController extends ChangeNotifier {
  String? _lgaId;
  String? _lgaName;
  String? _wardId;
  String? _wardName;
  String? _pollingUnitId;
  String? _pollingUnitName;

  String? get lgaId => _lgaId;
  String? get lgaName => _lgaName;
  String? get wardId => _wardId;
  String? get wardName => _wardName;
  String? get pollingUnitId => _pollingUnitId;
  String? get pollingUnitName => _pollingUnitName;

  bool get isStatewide => _lgaId == null;
  bool get isLga => _lgaId != null && _wardId == null;
  bool get isWard => _wardId != null && _pollingUnitId == null;
  bool get isPollingUnit => _pollingUnitId != null;

  String get label {
    if (_pollingUnitName != null) {
      return '${_pollingUnitName!} • ${_wardName ?? 'Ward'} • ${_lgaName ?? 'LGA'}';
    }
    if (_wardName != null) return '${_wardName!} • ${_lgaName ?? 'LGA'} LGA';
    if (_lgaName != null) return '${_lgaName!} LGA';
    return 'Benue State';
  }

  String get shortLabel => _lgaName ?? 'Statewide';

  void selectLga({required String id, required String name}) {
    final changed = _lgaId != id || _lgaName != name || _wardId != null;
    _lgaId = id;
    _lgaName = name;
    _wardId = null;
    _wardName = null;
    _pollingUnitId = null;
    _pollingUnitName = null;
    if (changed) notifyListeners();
  }

  void selectWard({
    required String lgaId,
    required String lgaName,
    required String wardId,
    required String wardName,
  }) {
    _lgaId = lgaId;
    _lgaName = lgaName;
    _wardId = wardId;
    _wardName = wardName;
    _pollingUnitId = null;
    _pollingUnitName = null;
    notifyListeners();
  }

  void selectPollingUnit({
    required String lgaId,
    required String lgaName,
    required String wardId,
    required String wardName,
    required String pollingUnitId,
    required String pollingUnitName,
  }) {
    _lgaId = lgaId;
    _lgaName = lgaName;
    _wardId = wardId;
    _wardName = wardName;
    _pollingUnitId = pollingUnitId;
    _pollingUnitName = pollingUnitName;
    notifyListeners();
  }

  void clearToLga() {
    if (_lgaId == null) return;
    _wardId = null;
    _wardName = null;
    _pollingUnitId = null;
    _pollingUnitName = null;
    notifyListeners();
  }

  void clearToStatewide() {
    if (isStatewide) return;
    _lgaId = null;
    _lgaName = null;
    _wardId = null;
    _wardName = null;
    _pollingUnitId = null;
    _pollingUnitName = null;
    notifyListeners();
  }
}

class CampaignScope extends InheritedNotifier<CampaignScopeController> {
  const CampaignScope({
    super.key,
    required CampaignScopeController controller,
    required super.child,
  }) : super(notifier: controller);

  static CampaignScopeController of(BuildContext context, {bool listen = true}) {
    if (listen) {
      final scope = context.dependOnInheritedWidgetOfExactType<CampaignScope>();
      assert(scope != null, 'CampaignScope is missing above this context.');
      return scope!.notifier!;
    }
    final element =
        context.getElementForInheritedWidgetOfExactType<CampaignScope>();
    final scope = element?.widget as CampaignScope?;
    assert(scope != null, 'CampaignScope is missing above this context.');
    return scope!.notifier!;
  }
}

class ActiveScopeBar extends StatelessWidget {
  const ActiveScopeBar({
    super.key,
    required this.onOpenMap,
  });

  final VoidCallback onOpenMap;

  @override
  Widget build(BuildContext context) {
    final scope = CampaignScope.of(context);
    return Material(
      color: Colors.white,
      child: Container(
        constraints: const BoxConstraints(minHeight: 48),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE2EAE4))),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 680;
            final content = Row(
              mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
              children: [
                const Icon(Icons.my_location_rounded,
                    size: 18, color: Color(0xFF0B7A3B)),
                const SizedBox(width: 8),
                const Text('Active scope:',
                    style: TextStyle(
                        color: Color(0xFF647067),
                        fontWeight: FontWeight.w700)),
                const SizedBox(width: 7),
                if (compact)
                  Text(scope.label,
                      style: const TextStyle(
                          color: Color(0xFF10231A),
                          fontWeight: FontWeight.w900))
                else
                  Flexible(
                    child: Text(
                      scope.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color(0xFF10231A),
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                if (!compact) const Spacer(),
                const SizedBox(width: 12),
                if (!scope.isStatewide)
                  TextButton.icon(
                    onPressed: scope.clearToStatewide,
                    icon: const Icon(Icons.public_rounded, size: 17),
                    label: const Text('Statewide'),
                  ),
                const SizedBox(width: 4),
                OutlinedButton.icon(
                  onPressed: onOpenMap,
                  icon: const Icon(Icons.map_outlined, size: 17),
                  label: const Text('Benue Map'),
                ),
              ],
            );

            if (!compact) return content;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: content,
            );
          },
        ),
      ),
    );
  }
}
