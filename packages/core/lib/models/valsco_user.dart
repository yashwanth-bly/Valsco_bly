import 'package:core/core.dart';

/// uid : "asfasdf"
/// name : ""
/// photo : ""

class ValscoUser extends Equatable {
  ValscoUser({
    String? uid,
    String? name,
    String? photo,
  }) {
    _uid = uid;
    _name = name;
    _photo = photo;
  }

  ValscoUser.fromJson(dynamic json) {
    _uid = json['uid'];
    _name = json['name'];
    _photo = json['photo'];
  }
  String? _uid;
  String? _name;
  String? _photo;
  ValscoUser copyWith({
    String? uid,
    String? name,
    String? photo,
  }) =>
      ValscoUser(
        uid: uid ?? _uid,
        name: name ?? _name,
        photo: photo ?? _photo,
      );
  String? get uid => _uid;
  String? get name => _name;
  String? get photo => _photo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uid'] = _uid;
    map['name'] = _name;
    map['photo'] = _photo;
    return map;
  }

  @override
  List<Object?> get props => [_uid, _name, _photo];
}
