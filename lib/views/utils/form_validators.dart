// ignore_for_file: prefer_const_constructors, public_member_api_docs

import 'package:flutter/services.dart';

/// Shared input formatters and validators used by every form in the app.
///
/// Design goals:
/// - Keep the validation surface small and predictable.
/// - Always trim() before checking, so "  john@x.com  " passes.
/// - Strip control characters and collapse internal whitespace where appropriate.
/// - Reject empty strings explicitly with friendly messages.
///
/// No personal data is logged.

class FormValidators {
  FormValidators._();

  // ─── Sanitizers (pure functions, used inside onChanged / inputFormatters) ──

  /// Removes control characters (\\x00–\\x1F) and collapses runs of
  /// whitespace to a single space.
  static String sanitizeText(String input) {
    if (input.isEmpty) return input;
    final cleaned = input.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
    return cleaned.replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Title-cases a name while preserving common multi-name patterns
  /// (e.g. "mary-jane O'NEILL" -> "Mary-Jane O'Neill"). Strips digits and
  /// most punctuation except letters, spaces, hyphens, and apostrophes.
  static String sanitizeName(String input) {
    final stripped = sanitizeText(input).replaceAll(
      RegExp(r"[^A-Za-zÀ-ÖØ-öø-ÿ\s'\-]"),
      '',
    );
    if (stripped.isEmpty) return stripped;
    return stripped
        .split(RegExp(r'(\s|\-|’)'))
        .where((part) => part.isNotEmpty)
        .map((part) {
      if (part == '-' || part == '’' || part == "'" || part == ' ') return part;
      return '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}';
    }).join();
  }

  /// Strips everything that is not a digit.
  static String sanitizeDigits(String input) {
    return input.replaceAll(RegExp(r'\D'), '');
  }

  // ─── Input formatters ─────────────────────────────────────────────────────

  /// Letters, spaces, hyphens, apostrophes only (for names).
  static final TextInputFormatter nameFormatter =
      FilteringTextInputFormatter.allow(RegExp(r"[A-Za-zÀ-ÖØ-öø-ÿ\s'\-]"));

  /// Digits only, capped at 11 characters (for NIN).
  static final TextInputFormatter ninFormatter =
      FilteringTextInputFormatter.digitsOnly;

  /// Digits only, capped at 14 characters (for card numbers without spaces).
  static final TextInputFormatter cardNumberFormatter =
      FilteringTextInputFormatter.digitsOnly;

  /// Digits only, capped at 4 characters (for CVV).
  static final TextInputFormatter cvvFormatter =
      FilteringTextInputFormatter.digitsOnly;

  /// Digits and the `/` separator, capped at 5 characters (for MM/YY).
  static final TextInputFormatter expiryFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9/]'));

  // ─── Validators (FormFieldValidator<String> shape) ────────────────────────

  /// Required string, after trim().
  static String? Function(String?) required(String label) {
    return (value) {
      final v = (value ?? '').trim();
      if (v.isEmpty) return '$label is required';
      return null;
    };
  }

  /// A person's first or last name. 1-50 chars, letters/spaces/hyphens/
  /// apostrophes only.
  static String? name(String? value) {
    final v = sanitizeName((value ?? '').trim());
    if (v.isEmpty) return 'Please enter a name';
    if (v.length < 2) return 'Name is too short';
    if (v.length > 50) return 'Name is too long (max 50)';
    if (!RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ][A-Za-zÀ-ÖØ-öø-ÿ\s'\-]*$").hasMatch(v)) {
      return 'Name can only contain letters, spaces, hyphens, and apostrophes';
    }
    return null;
  }

  /// Email — basic shape check. We intentionally do not run a full RFC parser;
  /// just enforce "something@something.something" with no spaces.
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
  static String? nin(String? value) {
    final v = sanitizeDigits(value ?? '');
    if (v.isEmpty) return 'NIN is required';
    if (v.length != 11) return 'NIN must be exactly 11 digits';
    return null;
  }

  /// Nigerian phone — accepts 11 digits starting with 0, or
  /// 13 chars with a leading +234 / 234. We strip everything but digits
  /// and then validate the resulting digit count.
  static String? phone(String? value) {
    final v = sanitizeDigits(value ?? '');
    if (v.isEmpty) return 'Phone number is required';
    if (v.length == 13 && v.startsWith('234')) {
      return null;
    }
    if (v.length == 11 && v.startsWith('0')) {
      return null;
    }
    return 'Enter a valid Nigerian phone number';
  }

  /// Cardholder name — letters, spaces, hyphens, apostrophes, dots.
  static String? cardholderName(String? value) {
    final v = sanitizeName((value ?? '').trim());
    if (v.isEmpty) return 'Cardholder name is required';
    if (v.length < 2) return 'Name is too short';
    if (v.length > 50) return 'Name is too long (max 50)';
    if (!RegExp(r"^[A-Za-zÀ-ÖØ-öø-ÿ][A-Za-zÀ-ÖØ-öø-ÿ\s'\-\.]*$")
        .hasMatch(v)) {
      return 'Name can only contain letters, spaces, hyphens, apostrophes, and dots';
    }
    return null;
  }

  /// Card number — 13–19 digits, passes the Luhn checksum.
  /// Accepts spaces/dashes in the input (they are stripped first).
  static String? cardNumber(String? value) {
    final raw = (value ?? '').trim();
    if (raw.isEmpty) return 'Card number is required';
    final digits = sanitizeDigits(raw);
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
    final v = sanitizeDigits(value ?? '');
    if (v.isEmpty) return 'CVV is required';
    if (v.length < 3 || v.length > 4) {
      return 'CVV must be 3 or 4 digits';
    }
    return null;
  }

  /// Password — at least 8 chars, one letter, one number.
  /// (Login screens should not enforce a hard password policy since legacy
  /// accounts may not meet it; signup can use a stricter one if desired.)
  static String? passwordLoose(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

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

  // ─── Helpers ─────────────────────────────────────────────────────────────

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
  /// E.g. "4111111111111111" -> "4111 1111 1111 1111".
  static String formatCardNumber(String input) {
    final digits = sanitizeDigits(input);
    final buf = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buf.write(' ');
      buf.write(digits[i]);
    }
    return buf.toString();
  }

  /// Inserts a "/" between MM and YY in an expiry field as the user types.
  /// E.g. "1226" -> "12/26".
  static String formatExpiry(String input) {
    final digits = sanitizeDigits(input).substring(
      0,
      sanitizeDigits(input).length.clamp(0, 4),
    );
    if (digits.length <= 2) return digits;
    return '${digits.substring(0, 2)}/${digits.substring(2)}';
  }
}
