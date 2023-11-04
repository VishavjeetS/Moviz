class AccessStateModel {
  int? id;
  bool? favorite;
  // Rated? rated;
  bool? watchlist;

  AccessStateModel({this.id, this.favorite, /*this.rated*/ this.watchlist});

  AccessStateModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    favorite = json['favorite'];
    // rated = json['rated'] != null ? Rated.fromJson(json['rated']) : null;
    watchlist = json['watchlist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['favorite'] = favorite;
    // if (rated != null) {
    //   data['rated'] = rated!.toJson();
    // }
    data['watchlist'] = watchlist;
    return data;
  }
}

class Rated {
  int? value;

  Rated({this.value});

  Rated.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['value'] = value;
    return data;
  }
}
