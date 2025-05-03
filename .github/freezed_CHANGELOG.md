## 3.0.0 - 2025-02-25

### New: Mixed mode

Freezed 3.0 is about supporting a "mixed mode".  
From now on, Freezed supports both the usual syntax:

```dart
@freezed
sealed class Usual with _$Usual {
  factory Usual({int a}) = _Usual;
}
```

But also:

```dart
@freezed
class Usual with _$Usual {
  Usual({this.a});
  final int a;
}
```

This has multiple benefits:

- Simple classes don't need Freezed's "weird" syntax and can stay simple
- Unions can keep using the usual `factory` syntax

This also offers a way to use all constructor features, such as initializers
or `super()`:

```dart
class Base {
  Base(String value);
}

@freezed
class Usual extends Base with _$Usual {
  Usual({int? a}) a = a ?? 0, super('value');
  final int a;
}
```

### New: Inheritance and non-constant default values.

When using Freezed, a common problem has always been the lack of `extends` support and non-constant default values.

Besides through "Mixed mode" mentioned above, Freezed now offers a way for `factory` constructors to specify non-constant defaults and a `super()`, by
relying on the `MyClass._()` constructor:

It also has another benefit:  
Complex Unions now have a way to use Inheritance and non-constant default values,
by relying on a non-factory `MyClass._()` constructor.

For context:  
Before, when a Freezed class specified a property or method,
it was required to specify a `MyClass._()` constructor:

```dart
@freezed
class Example with _$Example {
  // Necessary for helloWorld() to work
  Example._();
  factory Example(String name) = _Example

  void helloWorld() => print('Hello $name');
}
```

However, that `Example._()` constructor was required to have no parameter.

Starting Freezed 3.0, this constructor can accept any parameter.
Freezed will them pass it values from other `factory` constructors, based on name.

In short, this enables extending any class:

```dart
class Subclass {
  Subclass.name(this.value);
  final int value;
}

@freezed
class MyFreezedClass extends Subclass with _$MyFreezedClass {
  // We can receive parameters in this constructor, which we can use with `super.field`
  MyFreezedClass._(super.value): super.name();

  factory MyFreezedClass(int value, /* other fields */) = _MyFreezedClass;
}
```

It also enables non-constant default values:

```dart
@freezed
sealed class Response<T> with _$Response<T> {
  // We give "time" parameters a non-constant default
  Response._({DateTime? time}) : time = time ?? DateTime.now();
  // Constructors may enable passing parameters to ._();
  factory Response.data(T value, {DateTime? time}) = ResponseData;
  // If ._ parameters are named and optional, factory constructors are not required to specify it
  factory Response.error(Object error) = ResponseError;

  @override
  final DateTime time;
}
```

### New: "Eject" union cases

Along with the mixed mode, it is also possible to eject
a "union" case, by having it point to a custom class.

Concretely, you can do:

```dart
@freezed
sealed class Result<T> with _$Result {
  Result._();
  // Data does not exist, so Freezed will generate it as usual
  factory Result.data(T data) = ResultData;
  // We wrote a ResultError class in the same library, so Freezed won't do anything
  factory Result.error(Object error) = ResultError;
}

// We manually wrote `ResultError`
class ResultError<T> extends Result<T> {
  ResultError(this.error): super._();
  final Object error;
}
```

This combines nicely with "Mixed mode" mentioned previously,
as extracted union cases can also be Freezed classes:

```dart
// Using freezed with a simple class:
@freezed
class ResultError<T> extends Result<T> {
  ResultError(this.error): super._();
  final Object error;
}

// Or using a factory:
@freezed
class ResultError<T> extends Result<T> {
  ResultError._(): super._();
  factory ResultError(Object error) = _ResultError;
}
```

This feature offers fine-grained control over every parts of your models.

**Note**:
Unfortunately, it is kind of required to "extend" the parent class (so here `extends Result<T>`). This is because Dart doesn't support `sealed mixin class`, so you can't do
`with Result<T>` instead.

### Other changes:

- **Breaking**: Removed `map/when` and variants. These have been discouraged since Dart got pattern matching.
- **Breaking**: Freezed classes should now either be `abstract`, `sealed`, or manually implements `_$MyClass`.
- When formatting is disabled (default), Freezed now generates `// dart format off`. This
  prevents having to exclude generated file from formatting check in the CI.
- It is now possible to have a private constructor for unions:
  ```dart
  @freezed
  sealed class Result<T> with _$Result {
    // It wasn't possible to write _data before, but now is.
    factory Result._data(T data) = ResultData;
    factory Result.error(Object error) = ResultError;
  }
  ```