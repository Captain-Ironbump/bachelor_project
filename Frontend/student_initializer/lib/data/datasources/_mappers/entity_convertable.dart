mixin EntityConvertable<I, O> {
  O toEntity();
  I fromEntity(O model) => throw UnimplementedError();
}
