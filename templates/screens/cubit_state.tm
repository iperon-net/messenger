part of '{name}[-s]_cubit.dart';

@freezed
abstract class {name}[-C]State with _${name}[-C]State {
    const {name}[-C]State._();

  const factory {name}[-C]State({
    @Default(Status.initial) Status status,
    @Default("") String errorMessage,
  }) = _{name}[-C]State;
}
