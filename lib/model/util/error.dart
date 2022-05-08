class BlindPostException implements Exception {
  String errorMessage() {
    return "You cannot read blind Post";
  }
}

class DuplicationException implements Exception {
  String errorMessage() {
    return "You cannot duplicate";
  }
}

class TokenTimeOutException implements Exception {
  String errorMessage() {
    return "your refresh token is invalid ";
  }
}

class InBlackListException implements Exception {
  String errorMessage() {
    return "you are banned by this album owner ";
  }
}