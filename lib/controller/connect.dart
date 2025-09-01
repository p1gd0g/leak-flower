import 'dart:async';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:get/get.dart';
import 'package:leak_flower/controller/data.dart';
import 'package:leak_flower/controller/pocketbase.dart';
import 'package:pocketbase/pocketbase.dart';

class ConnectController extends GetConnect {
  Map<int, Rx<OutputCard>> outputCards = {};

  Future<Response<OutputCard?>> getMovieData(MovieRecord movieRecord) async {
    final movieID = movieRecord.doubanID;
    final pbc = Get.put(PBController());

    Rating? rating;
    try {
      final record = await pbc.pb
          .collection(collectionRatings)
          .getFirstListItem(
            // '$fieldDoubanID="$movieID" && $fieldUser="${pbc.authStore.record?.id}"',
            '$fieldMovieID="${movieRecord.id}" && $fieldUser="${pbc.authStore.record?.id}"',
          );
      // Get.log('Rating for movie $movieID: ${record.data}');
      rating = Rating.fromJson(record.data);
    } on ClientException catch (e) {
      Get.log('No rating found for movie $movieID: $e');
    }

    final url = 'https://api.eo.p1gd0g.cc';
    return await get<OutputCard?>(
      url,
      decoder: (data) {
        final doc = parse(data);
        var outputCard = OutputCard(
          imgUrl: getUrlStr(doc),
          rating: rating,
          title: getTitle(doc),
        );
        outputCards[movieID!] = outputCard.obs;

        return outputCard;
      },
      query: {'id': movieID.toString()},
    );
  }

  String? getUrlStr(Document doc) {
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
    return urlstr;
  }

  String? getTitle(Document doc) {
    var ele = doc.getElementsByClassName('main-title').firstOrNull;
    if (ele == null) {
      return null;
    }
    return ele.text.trim();
  }


}
