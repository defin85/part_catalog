import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:part_catalog/core/ui/themes/app_constants.dart';
import 'package:part_catalog/core/ui/atoms/inputs/text_input.dart' as ui_text_input;

/// Поле ввода с встроенной валидацией и отображением состояний
class ValidationField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final String? value;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final String? prefixText;
  final String? suffixText;
  final ui_text_input.InputSize size;
  final bool autofocus;

  // Параметры валидации
  final List<ValidationRule> validationRules;
  final bool validateOnChange;
  final bool validateOnFocusLost;
  final bool showValidationIcon;
  final Duration? debounceValidation;

  const ValidationField({
    super.key,
    this.label,
    this.hint,
    this.helperText,
    this.value,
    this.onChanged,
    this.onTap,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.inputFormatters,
    this.prefixIcon,
    this.prefixText,
    this.suffixText,
    this.size = ui_text_input.InputSize.medium,
    this.autofocus = false,
    this.validationRules = const [],
    this.validateOnChange = true,
    this.validateOnFocusLost = true,
    this.showValidationIcon = true,
    this.debounceValidation,
  });

  @override
  State<ValidationField> createState() => _ValidationFieldState();
}

class _ValidationFieldState extends State<ValidationField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  ValidationResult? _validationResult;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    if (widget.value != null) {
      _controller.text = widget.value!;
    }

    if (widget.validateOnChange) {
      _controller.addListener(_onTextChanged);
    }

    if (widget.validateOnFocusLost) {
      _focusNode.addListener(_onFocusChanged);
    }

    // Выполняем начальную валидацию, если есть значение
    if (_controller.text.isNotEmpty) {
      _validateValue(_controller.text);
    }
  }

  @override
  void didUpdateWidget(ValidationField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.value != _controller.text) {
      _controller.text = widget.value ?? '';
      _validateValue(_controller.text);
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (widget.controller == null) _controller.dispose();
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final value = _controller.text;
    widget.onChanged?.call(value);

    if (widget.validateOnChange) {
      if (widget.debounceValidation != null) {
        _debounceTimer?.cancel();
        _debounceTimer = Timer(widget.debounceValidation!, () {
          _validateValue(value);
        });
      } else {
        _validateValue(value);
      }
    }
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus && widget.validateOnFocusLost) {
      _validateValue(_controller.text);
    }
  }

  void _validateValue(String value) {
    if (widget.validationRules.isEmpty) return;

    ValidationResult? result;

    for (final rule in widget.validationRules) {
      final ruleResult = rule.validate(value);
      if (ruleResult != null) {
        result = ruleResult;
        break; // Останавливаемся на первой ошибке
      }
    }

    if (result != _validationResult) {
      setState(() {
        _validationResult = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ui_text_input.TextInput(
      controller: _controller,
      focusNode: _focusNode,
      label: widget.label,
      hint: widget.hint,
      helperText: widget.helperText,
      errorText: _validationResult?.message,
      onTap: widget.onTap,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      obscureText: widget.obscureText,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.showValidationIcon ? _buildValidationIcon() : null,
      prefixText: widget.prefixText,
      suffixText: widget.suffixText,
      size: widget.size,
      autofocus: widget.autofocus,
    );
  }

  Widget? _buildValidationIcon() {
    if (_validationResult == null) return null;

    IconData iconData;
    Color iconColor;

    switch (_validationResult!.type) {
      case ValidationResultType.success:
        iconData = Icons.check_circle;
        iconColor = Colors.green;
        break;
      case ValidationResultType.warning:
        iconData = Icons.warning;
        iconColor = Colors.orange;
        break;
      case ValidationResultType.error:
        iconData = Icons.error;
        iconColor = Theme.of(context).colorScheme.error;
        break;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: _getValidationIconSize(),
    );
  }

  double _getValidationIconSize() {
    switch (widget.size) {
      case ui_text_input.InputSize.small:
        return AppSizes.iconSm;
      case ui_text_input.InputSize.medium:
        return AppSizes.iconMd;
      case ui_text_input.InputSize.large:
        return AppSizes.iconLg;
    }
  }
}

/// Результат валидации поля
class ValidationResult {
  final ValidationResultType type;
  final String message;

  const ValidationResult({
    required this.type,
    required this.message,
  });

  const ValidationResult.success(this.message) : type = ValidationResultType.success;
  const ValidationResult.warning(this.message) : type = ValidationResultType.warning;
  const ValidationResult.error(this.message) : type = ValidationResultType.error;

  bool get isValid => type != ValidationResultType.error;
}

/// Типы результатов валидации
enum ValidationResultType {
  success,
  warning,
  error,
}

/// Базовый класс для правил валидации
abstract class ValidationRule {
  const ValidationRule();

  /// Возвращает null если валидация прошла успешно,
  /// иначе ValidationResult с описанием ошибки
  ValidationResult? validate(String value);
}

/// Правило обязательного поля
class RequiredRule extends ValidationRule {
  final String message;

  const RequiredRule([this.message = 'Поле обязательно для заполнения']);

  @override
  ValidationResult? validate(String value) {
    if (value.trim().isEmpty) {
      return ValidationResult.error(message);
    }
    return null;
  }
}

/// Правило минимальной длины
class MinLengthRule extends ValidationRule {
  final int minLength;
  final String? message;

  const MinLengthRule(this.minLength, [this.message]);

  @override
  ValidationResult? validate(String value) {
    if (value.length < minLength) {
      return ValidationResult.error(
        message ?? 'Минимум $minLength символов',
      );
    }
    return null;
  }
}

/// Правило максимальной длины
class MaxLengthRule extends ValidationRule {
  final int maxLength;
  final String? message;

  const MaxLengthRule(this.maxLength, [this.message]);

  @override
  ValidationResult? validate(String value) {
    if (value.length > maxLength) {
      return ValidationResult.error(
        message ?? 'Максимум $maxLength символов',
      );
    }
    return null;
  }
}

/// Правило email валидации
class EmailRule extends ValidationRule {
  final String message;

  const EmailRule([this.message = 'Введите корректный email']);

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  ValidationResult? validate(String value) {
    if (value.isNotEmpty && !_emailRegExp.hasMatch(value)) {
      return ValidationResult.error(message);
    }
    return null;
  }
}

/// Правило валидации телефона
class PhoneRule extends ValidationRule {
  final String message;

  const PhoneRule([this.message = 'Введите корректный номер телефона']);

  static final RegExp _phoneRegExp = RegExp(r'^\+?[\d\s\-\(\)]+$');

  @override
  ValidationResult? validate(String value) {
    if (value.isNotEmpty && !_phoneRegExp.hasMatch(value)) {
      return ValidationResult.error(message);
    }
    return null;
  }
}

/// Правило валидации URL
class UrlRule extends ValidationRule {
  final String message;

  const UrlRule([this.message = 'Введите корректный URL']);

  @override
  ValidationResult? validate(String value) {
    if (value.isNotEmpty) {
      try {
        final uri = Uri.parse(value);
        if (!uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https')) {
          return ValidationResult.error(message);
        }
      } catch (e) {
        return ValidationResult.error(message);
      }
    }
    return null;
  }
}

/// Правило регулярного выражения
class RegexRule extends ValidationRule {
  final RegExp regex;
  final String message;

  const RegexRule(this.regex, this.message);

  @override
  ValidationResult? validate(String value) {
    if (value.isNotEmpty && !regex.hasMatch(value)) {
      return ValidationResult.error(message);
    }
    return null;
  }
}

/// Кастомное правило валидации
class CustomRule extends ValidationRule {
  final ValidationResult? Function(String value) validator;

  const CustomRule(this.validator);

  @override
  ValidationResult? validate(String value) {
    return validator(value);
  }
}

