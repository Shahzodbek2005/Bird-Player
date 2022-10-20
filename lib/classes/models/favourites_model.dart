class ListFavoutes {
  final List<FavouritesModel> favourites;
  ListFavoutes({
    required this.favourites,
  });

  factory ListFavoutes.fromMap(List<dynamic> list) {
    return ListFavoutes(
      favourites: list.map((e) => FavouritesModel.fromMap(e)).toList(),
    );
  }
}

class FavouritesModel {
  final String id;
  final String songName;
  final String artist;
  final String path;
  FavouritesModel({
    required this.id,
    required this.songName,
    required this.artist,
    required this.path,
  });

  factory FavouritesModel.fromMap(Map<String, dynamic> map) {
    return FavouritesModel(
      id: map['id'] as String,
      songName: map['songName'] as String,
      artist: map['artist'] as String,
      path: map['path'] as String,
    );
  }
}
