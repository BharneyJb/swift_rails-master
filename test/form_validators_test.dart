import 'package:flutter_test/flutter_test.dart';
import 'package:swyft_rails/views/utils/form_validators.dart';

void main() {
  group('FormValidators.sanitizeName', () {
    test('title-cases simple names', () {
      expect(FormValidators.sanitizeName('mary jane'), 'Mary Jane');
      expect(FormValidators.sanitizeName("O'NEILL"), "O'Neill");
    });

    test('preserves hyphens and apostrophes', () {
      expect(FormValidators.sanitizeName('mary-jane'), 'Mary-Jane');
      expect(FormValidators.sanitizeName("john o'connor"), "John O'Connor");
    });

    test('strips digits and punctuation', () {
      expect(FormValidators.sanitizeName('john123!@#'), 'John');
    });

    test('strips control characters', () {
      expect(FormValidators.sanitizeName('john\x00\x01 doe'), 'John Doe');
    });
  });

  group('FormValidators.sanitizeDigits', () {
    test('keeps only digits', () {
      expect(FormValidators.sanitizeDigits('4111-1111 a1111'), '41111111');
    });
  });

  group('FormValidators.name validator', () {
    test('rejects empty', () {
      expect(FormValidators.name(''), isNotNull);
      expect(FormValidators.name(null), isNotNull);
      expect(FormValidators.name('   '), isNotNull);
    });

    test('accepts valid names', () {
      expect(FormValidators.name('Mary'), isNull);
      expect(FormValidators.name("O'Connor"), isNull);
    });

    test('rejects digits and special chars', () {
      expect(FormValidators.name('John123'), isNotNull);
      expect(FormValidators.name('a'), isNotNull); // too short
    });
  });

  group('FormValidators.email validator', () {
    test('accepts common shapes', () {
      expect(FormValidators.email('user@example.com'), isNull);
      expect(FormValidators.email('  user.name+tag@sub.example.co  '), isNull);
    });

    test('rejects malformed', () {
      expect(FormValidators.email('user@'), isNotNull);
      expect(FormValidators.email('user@host'), isNotNull);
      expect(FormValidators.email('user host@x.com'), isNotNull);
    });
  });

  group('FormValidators.nin validator', () {
    test('requires 11 digits', () {
      expect(FormValidators.nin('12345678901'), isNull);
      expect(FormValidators.nin('1234567890'), isNotNull);
      expect(FormValidators.nin('123456789012'), isNotNull);
      expect(FormValidators.nin(''), isNotNull);
    });

    test('strips non-digits before checking', () {
      expect(FormValidators.nin('12345-678-901'), isNotNull); // wrong length after strip
    });
  });

  group('FormValidators.phone validator', () {
    test('accepts 0-leading 11-digit Nigerian numbers', () {
      expect(FormValidators.phone('08012345678'), isNull);
    });

    test('accepts +234 13-digit', () {
      expect(FormValidators.phone('+2348012345678'), isNull);
      expect(FormValidators.phone('2348012345678'), isNull);
    });

    test('rejects wrong length', () {
      expect(FormValidators.phone('0801234567'), isNotNull);
      expect(FormValidators.phone(''), isNotNull);
    });
  });

  group('FormValidators.cardNumber validator (Luhn)', () {
    test('accepts known-good test numbers', () {
      // Visa test number
      expect(FormValidators.cardNumber('4111 1111 1111 1111'), isNull);
      // Mastercard test number
      expect(FormValidators.cardNumber('5500 0000 0000 0004'), isNull);
    });

    test('rejects non-Luhn numbers', () {
      expect(FormValidators.cardNumber('4111 1111 1111 1112'), isNotNull);
    });

    test('rejects wrong length', () {
      expect(FormValidators.cardNumber('123'), isNotNull);
      expect(FormValidators.cardNumber(''), isNotNull);
    });
  });

  group('FormValidators.expiry validator', () {
    test('accepts future MM/YY', () {
      expect(FormValidators.expiry('12/99'), isNull);
    });

    test('rejects past dates', () {
      expect(FormValidators.expiry('01/20'), isNotNull);
    });

    test('rejects malformed', () {
      expect(FormValidators.expiry('13/26'), isNotNull);
      expect(FormValidators.expiry('1/26'), isNotNull);
      expect(FormValidators.expiry('ab/cd'), isNotNull);
    });
  });

  group('FormValidators.cvv validator', () {
    test('accepts 3-4 digits', () {
      expect(FormValidators.cvv('123'), isNull);
      expect(FormValidators.cvv('1234'), isNull);
    });

    test('rejects wrong length', () {
      expect(FormValidators.cvv('12'), isNotNull);
      expect(FormValidators.cvv('12345'), isNotNull);
    });
  });

  group('FormValidators.passwordLoose', () {
    test('requires min 6 chars', () {
      expect(FormValidators.passwordLoose(''), isNotNull);
      expect(FormValidators.passwordLoose('12345'), isNotNull);
      expect(FormValidators.passwordLoose('123456'), isNull);
    });
  });

  group('FormValidators.formatCardNumber', () {
    test('inserts a space every 4 digits', () {
      expect(FormValidators.formatCardNumber('4111111111111111'),
          '4111 1111 1111 1111');
      expect(FormValidators.formatCardNumber('5500 0000 0000 0004'),
          '5500 0000 0000 0004');
    });
  });

  group('FormValidators.formatExpiry', () {
    test('inserts slash after 2 digits', () {
      expect(FormValidators.formatExpiry('1226'), '12/26');
      expect(FormValidators.formatExpiry('12'), '12');
      expect(FormValidators.formatExpiry('1'), '1');
    });
  });
}
