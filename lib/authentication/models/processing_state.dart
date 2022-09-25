/// Processing state.
enum ProcessingState {
  ///
  loading,

  ///
  loaded;

  /// Returns true if the state is [ProcessingState.loading].
  bool get isLoading => this == ProcessingState.loading;
}
