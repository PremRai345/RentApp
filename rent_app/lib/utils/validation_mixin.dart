class ValidationMixin {
  String? validateEmail(String value) {
    if (value.trim().isEmpty) {
      return "Please enter email";
    }
    return null;
  }

  String? validatePassword(String value,
      {bool isConfirmPassword = false, String confirmValue = ""}) {
    if (value.trim().isEmpty) {
      return "Please enter password";
    }
    if (isConfirmPassword) {
      if (value != confirmValue) {
        return "Your passwords does not match";
      }
    }
    return null;
  }
}
