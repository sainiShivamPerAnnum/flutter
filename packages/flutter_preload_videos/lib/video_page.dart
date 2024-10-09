import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'src/bloc/preload_bloc.dart';
import 'package:video_player/video_player.dart';

class ShortsVideoPage extends StatelessWidget {
  const ShortsVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PreloadBloc, PreloadState>(
      builder: (context, state) {
        return PageView.builder(
          itemCount: state.urls.length,
          scrollDirection: Axis.vertical,
          onPageChanged: (index) =>
              BlocProvider.of<PreloadBloc>(context, listen: false)
                  .add(PreloadEvent.onVideoIndexChanged(index)),
          itemBuilder: (context, index) {
            // Is at end and isLoading
            final bool isLoading =
                (state.isLoading && index == state.urls.length - 1);
    
            return state.focusedIndex == index
                ? VideoWidget(
                    isLoading: isLoading,
                    controller: state.controllers[index]!,
                  )
                : const SizedBox();
          },
        );
      },
    );
  }
}

/// Custom Feed Widget consisting video
class VideoWidget extends StatelessWidget {
  const VideoWidget({super.key, 
    required this.isLoading,
    required this.controller,
  });

  final bool isLoading;
  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: VideoPlayer(controller)),
        AnimatedCrossFade(
          alignment: Alignment.bottomCenter,
          sizeCurve: Curves.decelerate,
          duration: const Duration(milliseconds: 400),
          firstChild: const Padding(
            padding: EdgeInsets.all(10.0),
            child: CupertinoActivityIndicator(
              color: Colors.white,
              radius: 8,
            ),
          ),
          secondChild: const SizedBox(),
          crossFadeState:
              isLoading ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        ),
      ],
    );
  }
}
