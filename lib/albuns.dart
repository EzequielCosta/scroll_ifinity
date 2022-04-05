import 'package:scroll_infinity/album.dart';

class Albuns {
  List<Album> _albuns = [];

  void add(Album album) {
    _albuns.add(album);
  }

  Album getAlbum(int index) {
    return _albuns[index];
  }

  get albuns => _albuns;

  int getLenght() {
    return _albuns.length;
  }
}
