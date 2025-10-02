class FormValidators {
  static String? email(String? email) {
    if (email == null || email.isEmpty) return "Email is required";
    if (!RegExp(r'^[\w.-]+@[a-zA-Z\d.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? password(String? password) {
    if (password == null || password.isEmpty) return "Password is required";
    if (password.length < 8) return "Password must be at least 8 characters";
    return null;
  }

  static String? confirmPassword(String? confirmPassword, String? password) {
    if (confirmPassword == null || confirmPassword.isEmpty) return "Please Confirm Password";
    if (confirmPassword != password) return "Passwords do not match";
    return null;
  }

  static String? name(String? name) {
    if (name == null || name.isEmpty) return "Name is required";
    if (name.length < 2) return "Name must be at least 2 characters";
    return null;
  }

  static String? dob(DateTime? date) {
    if (date == null) return "Please select your DOB";
    final now = DateTime.now();
    final age = now.year - date.year - ((now.month < date.month || (now.month == date.month && now.day < date.day)) ? 1 : 0);
    if (age < 16) return "You must be at least 16 years old";
    return null;
  }

  static String? contact(String? value) {
    if (value == null || value.isEmpty) return "This field is required";
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return "Must be exactly 10 digits";
    }
    return null;
  }

  static String? areaCode(String? value) {
    if (value == null || value.isEmpty) return "This field is required";
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "Area code must be numeric";
    }
    return null;
  }

  static String? bloodGroup(String? value) {
    if (value == null || value.isEmpty) return "Please select your Blood Group";
    return null;
  }
}