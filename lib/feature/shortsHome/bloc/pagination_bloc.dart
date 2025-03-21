import 'package:felloapp/core/model/shorts/shorts_home.dart';
import 'package:felloapp/core/repository/shorts_repo.dart';
import 'package:felloapp/feature/shorts/src/service/video_data.dart';
import 'package:felloapp/util/api_response.dart';
import 'package:felloapp/util/bloc_pagination/bloc_pagination.dart';

class ThemeVideosBloc
    extends PaginationBloc<VideoData, PaginatedShorts, int, String> {
  final String theme;
  final String themeName;
  final num totalPages;
  final num total;
  final List<VideoData> initialVideos;

  ThemeVideosBloc({
    required ShortsRepository shortsRepo,
    required this.theme,
    required this.initialVideos,
    required this.themeName,
    required this.totalPages,
    required this.total,
  }) : super(
          initialPageReference: 0,
          resultConverterCallback: (result) {
            return result.videos;
          },
          paginationCallBack: (pageReference) async {
            if (pageReference == 0) {
              return PaginationResult.success(
                result: PaginatedShorts(
                  theme: theme,
                  themeName: themeName,
                  videos: initialVideos,
                  page: 1,
                  totalPages: totalPages,
                  total: total,
                ),
              );
            } else {
              ApiResponse<PaginatedShorts> response =
                  await shortsRepo.getPaginatedResponse(
                theme: theme,
                page: pageReference,
                limit: 6,
              );
              if (response.isSuccess()) {
                return PaginationResult.success(result: response.model!);
              } else {
                return PaginationResult.failure(
                  error: response.errorMessage ?? 'Error occurred',
                );
              }
            }
          },
          referenceConverterCallBack: (result, previousState, interrupter) {
            if (previousState + 1 >= result.totalPages) {
              interrupter.call();
              return result.page.toInt();
            }
            return (result.page + 1).toInt();
          },
        );
}
