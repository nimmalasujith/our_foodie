import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_foodie/test.dart';
import 'package:our_foodie/uploader.dart';

import 'test.dart';

import 'package:cloud_firestore/cloud_firestore.dart';







Future<void> CreateSubject({
  required String id,
  required String address,
  required CoordinatesConvertor coordinates,
  required List<String> tags,
  bool isUpdate = false,
  required String places,
  required FileUploader thumbnail,
  required Name headings,
  required ContactsConvertor contacts,
  required List<ReviewsConvertor> reviews,
  required String Description,
  required List<Rating> ratings,
}) async {
  final docTrip = FirebaseFirestore.instance
      .collection('foodPlaces')
      .doc(places)
      .collection("foodShops")
      .doc(id);

  final tripData = ShopDetailsConvertor(
      id: id,
      coordinates: coordinates,
      contacts: contacts,
      address: address,
      thumbnail: thumbnail,
      tags: tags,
      rating: ratings,
      about: Description,
      reviews: reviews,
      headings: headings, images: [], createdBy: CreatedByConvertor(name: "", email: ""));

  final jsonData = tripData.toJson();
  if (isUpdate) {
    await docTrip.update(jsonData);
  } else {
    await docTrip.set(jsonData);
  }
}

class ShopDetailsConvertor {
  final String id;
  final CoordinatesConvertor coordinates;
  final String about;
  final String address;
  final FileUploader thumbnail;
  final List<FileUploader> images;
  final Name headings;
  final CreatedByConvertor createdBy;
  final List<String> tags;
  final List<Rating> rating;
  final List<ReviewsConvertor> reviews;
  final ContactsConvertor contacts;

  ShopDetailsConvertor({
    required this.id,
    required this.coordinates,
    required this.contacts,
    required this.address,
    required this.thumbnail,
    required this.images,
    required this.tags,
    required this.createdBy,
    required this.headings,
    required this.rating,
    required this.about,
    required this.reviews,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "coordinates": coordinates.toJson(),
    "about": about,
    "address": address,
    "tags": tags,
    "createdBy": createdBy.toJson(),
    "thumbnail": thumbnail.toJson(),
    "rating": rating.map((unit) => unit.toJson()).toList(),
    "images": images.map((unit) => unit.toJson()).toList(),
    "headings": headings.toJson(),
    "reviews": reviews.map((review) => review.toJson()).toList(),
    "contacts": contacts.toJson(),
  };

  static ShopDetailsConvertor fromJson(Map<String, dynamic> json) =>
      ShopDetailsConvertor(
        id: json['id'] ?? "",
        coordinates: CoordinatesConvertor.fromJson(json['coordinates'] ?? {}),
        address: json['address'] ?? "",
        about: json['about'] ?? "",
        tags: List<String>.from(json['tags'] ?? []),
        thumbnail: FileUploader.fromJson(json['thumbnail'] ?? {}),
        createdBy: CreatedByConvertor.fromJson(json['createdBy'] ?? {}),
        contacts: ContactsConvertor.fromJson(json['contacts'] ?? {}),
        rating: Rating.fromMapList(json['rating'] ?? []),
        headings: Name.fromJson(json['headings'] ?? {}),
        reviews: ReviewsConvertor.fromMapList(json['reviews'] ?? []),
        images: FileUploader.fromMapList(json['images'] ?? []),
      );

  static List<ShopDetailsConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class CoordinatesConvertor {
  late  double latitude;
  late  double longitude;

  CoordinatesConvertor({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };

  static CoordinatesConvertor fromJson(Map<String, dynamic> json) => CoordinatesConvertor(
    latitude: json['latitude'] ?? 0.0,
    longitude: json['longitude'] ?? 0.0,
  );
}


class Name {
  final String commonName;
  final String shopName;

  Name({
    required this.shopName,
    required this.commonName,
  });

  Map<String, dynamic> toJson() =>
      {"shopName": shopName, "commonName": commonName};

  static Name fromJson(Map<String, dynamic> json) => Name(
        commonName: json['commonName'] ?? "",
        shopName: json["shopName"] ?? "",
      );

  static List<Name> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class Rating {
  final String UserId;
  final double RatingNo;

  Rating({
    required this.UserId,
    required this.RatingNo,
  });

  Map<String, dynamic> toJson() => {
        "id": UserId,
        "ratingNo": RatingNo,
      };

  static Rating fromJson(Map<String, dynamic> json) => Rating(
        UserId: json['id'] ?? "",
        RatingNo: json['ratingNo'] ?? 0.0,
      );

  static List<Rating> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class DescriptionAndQuestionConvertor {
  late final String data;
  late final int pageNumber;

  DescriptionAndQuestionConvertor({
    required this.pageNumber,
    required this.data,
  });

  Map<String, dynamic> toJson() => {"pageNumber": pageNumber, "data": data};

  static DescriptionAndQuestionConvertor fromJson(Map<String, dynamic> json) =>
      DescriptionAndQuestionConvertor(
        data: json['data'] ?? "",
        pageNumber: json["pageNumber"] ?? 0,
      );

  static List<DescriptionAndQuestionConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class ReviewsConvertor {
  final String id, data;

  ReviewsConvertor({
    required this.id,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "data": data,
      };

  static ReviewsConvertor fromJson(Map<String, dynamic> json) =>
      ReviewsConvertor(
        id: json['id'] ?? "",
        data: json['data'] ?? "",
      );

  static List<ReviewsConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class ContactsConvertor {
  final List<dynamic> numbers;
  final List<dynamic> emails;

  ContactsConvertor({
    required this.numbers,
    required this.emails,
  });

  Map<String, dynamic> toJson() => {
        "numbers": numbers,
        "emails": emails,
      };

  static ContactsConvertor fromJson(Map<String, dynamic> json) =>
      ContactsConvertor(
        numbers: json['numbers'] ?? [],
        emails: json['emails'] ?? [],
      );

  static List<ContactsConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class CreatedByConvertor {
  final String name;
  final String email;

  CreatedByConvertor({
    required this.name,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
      };

  static CreatedByConvertor fromJson(Map<String, dynamic> json) =>
      CreatedByConvertor(
        name: json['name'] ?? "",
        email: json['email'] ?? "",
      );

  static List<CreatedByConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}
