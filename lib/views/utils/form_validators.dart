// ignore_for_file: prefer_const_constructors, public_member_api_docs

import 'package:flutter/services.dart';

/// Shared input formatters and validators used by every form in the app.

class FormValidators {
  FormValidators._();

  // ─── Sanitizers ────────────────────────────────────────────────────────────

  /// Removes control characters and collapses runs of whitespace to a single space.
  static String sanitizeText(String input) {
    if (input.isEmpty) return input;
    final cleaned = input.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
    return cleaned.replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Title-cases a name while preserving hyphens and apostrophes.
  /// Strips digits and most punctuation except letters, spaces, hyphens, apostrophes.
  static String sanitizeName(String input) {
    // Strip control chars first
    final sanitized = sanitizeText(input);
    // Keep only letters (including extended), spaces, hyphens, and apostrophes
    final stripped = sanitized.replaceAll(
      RegExp(r"[^A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u00FF\s'\-]"),
      '',
    );
    if (stripped.isEmpty) return stripped;

    final result = StringBuffer();
    // Match word tokens or delimiter tokens
    final tokenRegex =
        RegExp(r"[A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u00FF]+|[\s'\-]");
    for (final match in tokenRegex.allMatches(stripped)) {
      final token = match.group(0)!;
      if (token == ' ' || token == '-' || token == "'") {
        result.write(token);
      } else {
        result.write(
            '${token[0].toUpperCase()}${token.substring(1).toLowerCase()}');
      }
    }
    return result.toString();
  }

  /// Strips everything that is not a digit, then truncates to 8 characters.
  static String sanitizeDigits(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    return digits.length > 8 ? digits.substring(0, 8) : digits;
  }

  // ─── Input formatters ─────────────────────────────────────────────────────

  /// Letters, spaces, hyphens, apostrophes only (for names).
  static final TextInputFormatter nameFormatter =
      FilteringTextInputFormatter.allow(
          RegExp(r"[A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u00FF\s'\-]"));

  /// Digits only (for NIN).
  static final TextInputFormatter ninFormatter =
      FilteringTextInputFormatter.digitsOnly;

  /// Digits only (for card numbers without spaces).
  static final TextInputFormatter cardNumberFormatter =
      FilteringTextInputFormatter.digitsOnly;

  /// Digits only (for CVV).
  static final TextInputFormatter cvvFormatter =
      FilteringTextInputFormatter.digitsOnly;

  /// Digits and the `/` separator (for MM/YY).
  static final TextInputFormatter expiryFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9/]'));

  // ─── Validators ───────────────────────────────────────────────────────────

  /// Required string, after trim().
  static String? Function(String?) required(String label) {
    return (value) {
      final v = (value ?? '').trim();
      if (v.isEmpty) return '$label is required';
      return null;
    };
  }

  /// A person's first or last name — letters/spaces/hyphens/apostrophes only.
  static String? name(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) return 'Please enter a name';

    // Reject if input contains digits or disallowed special characters
    // Allowed: letters (including extended unicode), spaces, hyphens, apostrophes
    if (RegExp(r"[0-9!@#$%^&*()_+=\[\]{};:,.<>?/\\|`~]").hasMatch(raw)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }

    final v = sanitizeName(raw);
    if (v.isEmpty) return 'Please enter a name';
    if (v.length < 2) return 'Name is too short';
    if (v.length > 50) return 'Name is too long (max 50)';
    return null;
  }

  /// Email — basic shape check.
  static String? email(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Please enter your email';
    if (v.length > 254) return 'Email is too long';
    final emailRegex = RegExp(
      r"^[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,}$",
    );
    if (!emailRegex.hasMatch(v)) return 'Please enter a valid email address';
    return null;
  }

  /// NIN — exactly 11 digits.
  /// Strips non-digit characters from the input, then checks that the
  /// resulting string is exactly 11 digits AND the original input contained
  /// no non-digit characters (i.e. only pure digit strings are accepted).
  static String? nin(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) return 'NIN is required';
    // Strip non-digits and check length
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 11) return 'NIN must be exactly 11 digits';
    // Require that the trimmed original contained only digits
    if (!RegExp(r'^\d+$').hasMatch(raw)) {
      return 'NIN must be exactly 11 digits';
    }
    return null;
  }

  /// Nigerian phone — 11 digits starting with 0, or 13 digits with +234/234.
  static String? phone(String? value) {
    final v = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (v.isEmpty) return 'Phone number is required';
    if (v.length == 13 && v.startsWith('234')) return null;
    if (v.length == 11 && v.startsWith('0')) return null;
    return 'Enter a valid Nigerian phone number';
  }

  /// Cardholder name — letters, spaces, hyphens, apostrophes, dots.
  static String? cardholderName(String? value) {
    final v = sanitizeName((value ?? '').trim());
    if (v.isEmpty) return 'Cardholder name is required';
    if (v.length < 2) return 'Name is too short';
    if (v.length > 50) return 'Name is too long (max 50)';
    if (!RegExp(
            r"^[A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u00FF][A-Za-z\u00C0-\u00D6\u00D8-\u00F6\u00F8-\u00FF\s'\-\.]*$")
        .hasMatch(v)) {
      return 'Name can only contain letters, spaces, hyphens, apostrophes, and dots';
    }
    return null;
  }

  /// Card number — 13–19 digits, passes the Luhn checksum.
  static String? cardNumber(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) return 'Card number is required';
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 13 || digits.length > 19) {
      return 'Card number must be 13 to 19 digits';
    }
    if (!_luhnCheck(digits)) return 'Card number is not valid';
    return null;
  }

  /// Expiry — "MM/YY", not in the past.
  static String? expiry(String? value) {
    final v = (value ?? '').trim();
    if (v.isEmpty) return 'Expiry is required';
    final match = RegExp(r'^(0[1-9]|1[0-2])/(\d{2})$').firstMatch(v);
    if (match == null) return 'Use MM/YY format';
    final month = int.parse(match.group(1)!);
    final year = 2000 + int.parse(match.group(2)!);
    final now = DateTime.now();
    final endOfMonth = DateTime(year, month + 1, 0, 23, 59, 59);
    if (endOfMonth.isBefore(now)) return 'Card has expired';
    return null;
  }

  /// CVV — 3 or 4 digits.
  static String? cvv(String? value) {
    final v = (value ?? '').replaceAll(RegExp(r'\D'), '');
    if (v.isEmpty) return 'CVV is required';
    if (v.length < 3 || v.length > 4) return 'CVV must be 3 or 4 digits';
    return null;
  }

  /// Password — loose (min 6 chars).
  static String? passwordLoose(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  /// Password — strict (min 8 chars, one letter, one number).
  static String? passwordStrict(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Za-z]').hasMatch(v)) {
      return 'Password must contain at least one letter';
    }
    if (!RegExp(r'\d').hasMatch(v)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Luhn ("mod 10") checksum for credit/debit card numbers.
  static bool _luhnCheck(String digits) {
    var sum = 0;
    var alt = false;
    for (var i = digits.length - 1; i >= 0; i--) {
      var n = int.parse(digits[i]);
      if (alt) {
        n *= 2;
        if (n > 9) n -= 9;
      }
      sum += n;
      alt = !alt;
    }
    return sum % 10 == 0;
  }

  /// Inserts a space every 4 digits for a card number as the user types.
  static String formatCardNumber(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(digits[i]);
    }
    return buf.toString();
  }

  /// Inserts a "/" between MM and YY in an expiry field as the user types.
  static String formatExpiry(String input) {
    final allDigits = input.replaceAll(RegExp(r'\D'), '');
    final digits = allDigits.length > 4
        ? allDigits.substring(0, 4)
        : allDigits;
    if (digits.length <= 2) return digits;
    return '${digits.substring(0, 2)}/${digits.substring(2)}';
  }
}
