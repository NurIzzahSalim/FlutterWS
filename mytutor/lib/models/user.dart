class User{
  String? id;
  String? email;
  String? name;
  String? phone;
  String? address;
  String? datereg;

  User({this.id, this.email, this.name, this.phone, this.address, this.datereg});

  User.fromJson(Map<String, dynamic> json){
    id    = json["id"];
    email = json["email"];
    name  = json["name"];
    phone = json["phone"];
    address = json["address"];
    datereg = json["datereg"];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = id;
      data['email'] = email;
      data['name'] = name;
      data['phone'] = phone;
      data['address'] = address;
      data['datereg'] = datereg;
    return data;
  }
}