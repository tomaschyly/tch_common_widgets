import 'package:tch_appliable_core/tch_appliable_core.dart';

class LoadingBuilder extends StatelessWidget {
  final bool? isLoading;
  final List<String> loadingTags;
  final Widget Function(BuildContext context, bool isLoading) builder;

  /// LoadingBuilder initialization
  LoadingBuilder({
    super.key,
    this.isLoading,
    required this.builder,
    String? tag,
    List<String>? tags,
  }) : loadingTags = [
          if (tag != null) tag,
          if (tags != null) ...tags,
        ];

  /// Create view layout from widgets
  @override
  Widget build(BuildContext context) {
    final screenDataState = ScreenDataState.of(context);

    bool isLoading = false;

    if (screenDataState == null ||
        (screenDataState.loadingTags.isEmpty && loadingTags.isEmpty) ||
        (screenDataState.loadingTags.isNotEmpty && loadingTags.any((tag) => screenDataState.loadingTags.contains(tag)))) {
      isLoading = this.isLoading ?? screenDataState?.isLoading ?? false;
    }

    return builder(context, isLoading);
  }
}
