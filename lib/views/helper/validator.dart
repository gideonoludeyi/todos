class Validator {
  final String? Function(String? value) _validatorFn;

  Validator(this._validatorFn);

  String? validate(String? value) => _validatorFn(value);

  /// syntactic sugar for [validate]
  /// ```dart
  /// final validator = Validator.required(errorText: "Title is required");
  /// validator("some title"); // == validator.validate("some title");
  /// ```
  String? call(String? value) => validate(value);

  factory Validator.required({required String errorText}) => Validator((value) {
        if (value == null || value.trim().isEmpty) {
          return errorText;
        }
        return null;
      });

  factory Validator.minLength(int minLength, {required String errorText}) =>
      Validator((value) {
        if (value == null || value.trim().length < minLength) {
          return errorText;
        }
        return null;
      });

  factory Validator.maxLength(int maxLength, {required String errorText}) =>
      Validator((value) {
        if (value != null && value.trim().length > maxLength) {
          return errorText;
        }
        return null;
      });

  factory Validator.test(bool Function(String? value) testFn,
          {required String errorText}) =>
      Validator((value) {
        if (testFn(value)) return null;
        return errorText;
      });

  factory Validator.compose(List<Validator> validators) => Validator(
        (value) => validators
            .map((validator) => validator(value))
            .firstWhere((errorText) => errorText != null, orElse: () => null),
      );
}
