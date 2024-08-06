class RValidator {

//   static String? validateEmptyText(String? fieldName, String? value){
//     if(value==null || value.isEmpty){
//       return '$fieldName is required. ';
//     }
//     return null;
//   }
//   static String? validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Email is required.';
//     }
// // Regular expression for email validation
//     final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.) + [\w-]{2,4}$');

//     if (!emailRegExp.hasMatch(value)) {
//       return 'Invalid email address.';
//     }
//     return null;
//   }

//   static String? validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Password is required.';
//     }
//     if (value.length < 6) {
//       return 'Paaword must be at least 6 characters long. ';
//     }
//     //Check for uppercase letters
//     if (!value.contains(RegExp(r'[A-Z]'))) {
//       return 'Password must contain at least one uppercase letter.';
//     }
//     // Check for numbers
//     if (!value.contains(RegExp(r' [0-9]'))) {
//       return 'Password must contain at least one number.';
//     }
//     // Check for special characters
//     if (!value.contains(RegExp(r' [!@#$%^&* () , .?" :1}|<>]'))) {
//       return 'Password must contain at least one special character.';
//     }
//     return null;
//   }

//   static String? validatePhoneNumber(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Phone number is required.';
//     }
//     // Regular expression for phone number validation (assuming a 10-digit US phone number format)
//     final phoneRegExp = RegExp(r'^\d{10}$');
//     if (!phoneRegExp.hasMatch(value)) {
//       return 'Invalid phone number format (10 digits required).';
//     }
//     return null;
//   }


   static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long.';
    }
    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }
    // Check for lowercase letters
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter.';
    }
    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }
    // Regular expression for phone number validation (8 digits starting with 2, 3, or 4)
    final phoneRegExp = RegExp(r'^[234]\d{7}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (8 digits starting with 2, 3, or 4 required).';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirmation password is required.';
    }
    if (value != password) {
      return 'Passwords do not match.';
    }
    return null;
  }
}
