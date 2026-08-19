import 'auth_session.dart';

class AccessPolicy {
  const AccessPolicy(this._authSession);

  final AuthSession _authSession;

  bool get canManagePeople => _authSession.isTechLead;
  bool get canManageTeams => _authSession.isTechLead;
  bool get canManageIntegrations => _authSession.isTechLead;
  bool get canReadNotifications => _authSession.isTechLead;
  bool get canRunDaily => _authSession.isTechLead;

  String landingPath({
    required String homePath,
    required String profilePath,
    required String myPersonPath,
  }) {
    if (_authSession.isMember) {
      return profilePath;
    }

    return homePath;
  }

  bool canAccessRoute({
    required String matchedLocation,
    required String profilePath,
    required String myPersonPath,
    required String personDetailPath,
    required String personEditPath,
    String? personId,
  }) {
    if (!_authSession.hasResolvedAccess) {
      return true;
    }

    if (_authSession.isTechLead) {
      return true;
    }

    if (!_authSession.isMember) {
      return matchedLocation == profilePath;
    }

    if (matchedLocation == profilePath || matchedLocation == myPersonPath) {
      return true;
    }

    final currentPersonId = _authSession.personId?.toString();
    final isOwnPersonRoute =
        currentPersonId != null &&
        personId == currentPersonId &&
        (matchedLocation == personDetailPath ||
            matchedLocation == personEditPath);

    return isOwnPersonRoute;
  }
}
