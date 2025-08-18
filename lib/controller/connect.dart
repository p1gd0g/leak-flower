import 'dart:async';

import 'package:html/parser.dart';
import 'package:get/get.dart';

class ConnectController extends GetConnect {
  Future<Response<OutputCard?>> getMovieData(dynamic movieID) async {
    final url = 'https://api.eo.p1gd0g.cc';
    return await get<OutputCard?>(
      url,
      decoder: (data) {
        final doc = parse(data);
        // <div class="picture-wrapper" style="background-image: url(https://img1.doubanio.com/view/photo/m_ratio_poster/public/p2924250338.jpeg)">

        var ele = doc.getElementsByClassName('picture-wrapper').firstOrNull;
        if (ele == null) {
          return null;
        }

        // "background-image: url(https://img1.doubanio.com/view/photo/m_ratio_poster/public/p2924250338.jpeg)"
        var style = ele.attributes['style'];
        var urlstr = style?.split('url(').lastOrNull?.split(')').firstOrNull;
        if (urlstr == null) {
          return null;
        }

        urlstr = urlstr.replaceFirst('https://', 'https://md.p1gd0g.cc/');

        return OutputCard(imgUrl: urlstr);
      },
      query: {'id': movieID.toString()},
    );
  }
}

class OutputCard {
  String? imgUrl;

  OutputCard({this.imgUrl});
}
