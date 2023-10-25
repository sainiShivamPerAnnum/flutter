import 'package:path/path.dart' as p;

enum UrlType { IMAGE, VIDEO, UNKNOWN }

class UrlTypeHelper {
  static final List<String> _imagetypes = [
    'jpg',
    'jpeg',
    'jfif',
    'pjpeg',
    'pjp',
    'png',
    'svg',
    'gif',
    'apng',
    'webp',
    'avif'
  ];

  static final List<String> _videotypes = [
    "3g2",
    "3gp",
    "aaf",
    "asf",
    "avchd",
    "avi",
    "drc",
    "flv",
    "m2v",
    "m3u8",
    "m4p",
    "m4v",
    "mkv",
    "mng",
    "mov",
    "mp2",
    "mp4",
    "mpe",
    "mpeg",
    "mpg",
    "mpv",
    "mxf",
    "nsv",
    "ogg",
    "ogv",
    "qt",
    "rm",
    "rmvb",
    "roq",
    "svi",
    "vob",
    "webm",
    "wmv",
    "yuv"
  ];

  static UrlType getType(url) {
    try {
      Uri uri = Uri.parse(url);
      String extension = p.extension(uri.path).toLowerCase();
      if (extension.isEmpty) {
        return UrlType.UNKNOWN;
      }

      extension = extension.split('.').last;
      if (_imagetypes.contains(extension)) {
        return UrlType.IMAGE;
      } else if (_videotypes.contains(extension)) {
        return UrlType.VIDEO;
      }
    } catch (e) {
      return UrlType.UNKNOWN;
    }
    return UrlType.UNKNOWN;
  }
}
