class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? password;
  String? address;
  String? cart;

  User(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.password,
      this.address,
      this.cart});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    address = json['address'];
    cart = json['cart'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['address'] = address;
    data['cart'] = cart.toString();
    return data;
  }
}