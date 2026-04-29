/// Validators — Form validation helpers
class Validators {
  Validators._();

  /// Validate Nigerian phone number (10 digits after +234)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove spaces and country code
    final cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    final phoneNumber = cleaned.startsWith('+234') 
        ? cleaned.substring(4) 
        : cleaned.startsWith('234')
            ? cleaned.substring(3)
            : cleaned.startsWith('0')
                ? cleaned.substring(1)
                : cleaned;

    if (phoneNumber.length != 10) {
      return 'Phone number must be 10 digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(phoneNumber)) {
      return 'Phone number must contain only digits';
    }

    // Check if starts with valid Nigerian prefix (70-91)
    final prefix = int.tryParse(phoneNumber.substring(0, 2));
    if (prefix == null || prefix < 70 || prefix > 91) {
      return 'Invalid Nigerian phone number';
    }

    return null;
  }

  /// Validate email address
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }

    return null;
  }

  /// Validate name (at least 2 characters, letters and spaces only)
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (!RegExp(r"^[a-zA-Z\s\-']+$").hasMatch(value)) {
      return 'Name can only contain letters, spaces, hyphens and apostrophes';
    }

    return null;
  }

  /// Validate OTP (6 digits)
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }

    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }

    return null;
  }

  /// Validate required field
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate minimum length
  static String? validateMinLength(String? value, int minLength, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    if (value.length < minLength) {
      return '$fieldName must be at least $minLength characters';
    }

    return null;
  }

  /// Validate maximum length
  static String? validateMaxLength(String? value, int maxLength, String fieldName) {
    if (value != null && value.length > maxLength) {
      return '$fieldName must not exceed $maxLength characters';
    }
    return null;
  }

  /// Validate date is in the future
  static String? validateFutureDate(DateTime? value, String fieldName) {
    if (value == null) {
      return '$fieldName is required';
    }

    if (value.isBefore(DateTime.now())) {
      return '$fieldName must be in the future';
    }

    return null;
  }

  /// Validate date is not too far in the future (e.g., exam date within 2 years)
  static String? validateReasonableFutureDate(DateTime? value, String fieldName, {int maxYears = 2}) {
    if (value == null) {
      return '$fieldName is required';
    }

    final now = DateTime.now();
    if (value.isBefore(now)) {
      return '$fieldName must be in the future';
    }

    final maxDate = DateTime(now.year + maxYears, now.month, now.day);
    if (value.isAfter(maxDate)) {
      return '$fieldName cannot be more than $maxYears years in the future';
    }

    return null;
  }

  /// Validate URL
  static String? validateUrl(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL is optional
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Enter a valid URL';
    }

    return null;
  }

  /// Validate number range
  static String? validateNumberRange(int? value, int min, int max, String fieldName) {
    if (value == null) {
      return '$fieldName is required';
    }

    if (value < min || value > max) {
      return '$fieldName must be between $min and $max';
    }

    return null;
  }

  /// Format Nigerian phone number for display
  static String formatPhoneNumber(String phone) {
    // Remove all non-digit characters
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    
    // Extract the 10-digit number
    String number;
    if (cleaned.startsWith('234')) {
      number = cleaned.substring(3);
    } else if (cleaned.startsWith('0')) {
      number = cleaned.substring(1);
    } else {
      number = cleaned;
    }

    // Format as +234 XXX XXX XXXX
    if (number.length == 10) {
      return '+234 ${number.substring(0, 3)} ${number.substring(3, 6)} ${number.substring(6)}';
    }

    return phone; // Return original if can't format
  }

  /// Clean phone number to API format (10 digits)
  static String cleanPhoneNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');
    
    if (cleaned.startsWith('234')) {
      return cleaned.substring(3);
    } else if (cleaned.startsWith('0')) {
      return cleaned.substring(1);
    }
    
    return cleaned;
  }
}
