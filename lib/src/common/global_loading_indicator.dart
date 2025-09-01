import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingProvider = StateProvider<bool>((ref) => false);

class GlobalLoadingIndicator extends ConsumerStatefulWidget {
  final Widget child;

  const GlobalLoadingIndicator({required this.child, super.key});

  @override
  ConsumerState createState() => _GlobalLoadingIndicatorState();
}

class _GlobalLoadingIndicatorState
    extends ConsumerState<GlobalLoadingIndicator> {
  final List<OverlayEntry> _entries = [];

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(loadingProvider, (previous, next) {
      if (previous == next) {
        return;
      }
      if (next) {
        _entries.add(
          OverlayEntry(
            builder: (_) => ModalBarrier(
              dismissible: false,
              color: Colors.black12.withValues(alpha: 0.5),
            ),
          ),
        );
        _entries.add(
          OverlayEntry(
            builder: (_) => const Center(
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        );
        Overlay.of(context).insertAll(_entries);
      } else {
        for (var e in _entries) {
          e.remove();
        }
        _entries.clear();
      }
    });

    return Overlay(
      initialEntries: <OverlayEntry>[
        OverlayEntry(
          builder: (BuildContext ctx) {
            return widget.child;
          },
        ),
      ],
    );
  }
}
