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

  String? validate(String value, String title) {
    if (value.trim().isEmpty) {
      return "Please enter your $title";
    }
    return null;
  }

  String? validateAge(String value) {
    if (value.trim().isEmpty) {
      return "Please enter your age";
    } else if (int.tryParse(value) == null) {
      return "Please enter a numeric value";
    }
    if (int.parse(value) < 0 || int.parse(value) > 150) {
      return "Please enter age more than 0 and less than 150";
    }
    return null;
  }
}
