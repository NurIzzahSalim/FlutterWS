class Cart {
  String? cartid;
  String? subname;
  String? subqty;
  String? price;
  String? cartqty;
  String? subid;
  String? pricetotal;

  Cart(
      {this.cartid,
      this.subname,
      this.subqty,
      this.price,
      this.cartqty,
      this.subid,
      this.pricetotal});

  Cart.fromJson(Map<String, dynamic> json) {
    cartid = json['cartid'];
    subname = json['subname'];
    subqty = json['subqty'];
    price = json['price'];
    cartqty = json['cartqty'];
    subid = json['subid'];
    pricetotal = json['pricetotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cartid'] = cartid;
    data['subname'] = subname;
    data['prqty'] = subqty;
    data['price'] = price;
    data['cartqty'] = cartqty;
    data['subid'] = subid;
    data['pricetotal'] = pricetotal;
    return data;
  }
}