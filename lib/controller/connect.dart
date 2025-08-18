import 'package:get/get.dart';

class ConnectController extends GetConnect {
  Future<Response<OutputCard>> getMovieData(dynamic movieID) async {
    final url = 'https://api.eo.p1gd0g.cc';
    return await get<OutputCard>(
      url,
      decoder: (data) {
        Get.log('Decoding movie data from $data');
        Get.log('Decoding movie data from ${data.runtimeType}');
        return OutputCard();
      },
      query: {'id': movieID.toString()},
    );
  }
}

class OutputCard {
  String? imgUrl;
}
