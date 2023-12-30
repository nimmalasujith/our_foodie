import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:our_foodie/test.dart';

import 'test.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> CreateSubject({
  required String id, required String address, required String coordinates,
  required List<String> tags,
   bool isUpdate=false,
  required String places,
  required Images images,
  required Headings headings,
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

  final tripData = shopDetailsConvertor(
    id: id,
    coordinates: coordinates,
    contacts: contacts,
    address: address,
    images: images,
    tags: tags,
    rating: ratings,
    description: Description,
    reviews: reviews,
    headings: headings
  );

  final jsonData = tripData.toJson();
  if (isUpdate) {
    await docTrip.update(jsonData);
  } else {
    await docTrip.set(jsonData);
  }
}


class shopDetailsConvertor {
  final String id, coordinates, description, address;
  final Images images;
  final Headings headings;
  final List<String> tags;
  final List<Rating> rating;
  final List<ReviewsConvertor> reviews;
  final ContactsConvertor contacts;

  shopDetailsConvertor({
    required this.id,
    required this.coordinates,
    required this.contacts,
    required this.address,
    required this.images,
    required this.tags,
    required this.headings,
    required this.rating,
    required this.description,
    required this.reviews,
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "coordinates": coordinates,
    "description": description,
    "address": address,
    "tags": tags,
    "images": images.toJson(),
    "rating": rating.map((unit) => unit.toJson()).toList(),
    "headings": headings.toJson(),
    "reviews": reviews.map((review) => review.toJson()).toList(),
    "contacts": contacts.toJson(),
  };

  static shopDetailsConvertor fromJson(Map<String, dynamic> json) =>
      shopDetailsConvertor(
        id: json['id'] ?? "",
        coordinates: json['coordinates'] ?? "",
        address: json['address'] ?? "",
        description: json['description'] ?? "",
        tags: List<String>.from(json['tags'] ?? []),
        images: Images.fromJson(json['images'] ?? {}),
        contacts: ContactsConvertor.fromJson(json['contacts'] ?? {}),
        rating: Rating.fromMapList(json['rating'] ?? []),
        headings: Headings.fromJson(json['headings'] ?? {}),
        reviews: ReviewsConvertor.fromMapList(json['reviews'] ?? []),
      );

  static List<shopDetailsConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class Images {
  final String mainImage;
  final List<String> otherImages;

  Images({
    required this.otherImages,
    required this.mainImage,
  });

  Map<String, dynamic> toJson() => {"otherImages": otherImages, "mainImage": mainImage};

  static Images fromJson(Map<String, dynamic> json) =>
      Images(
        mainImage: json['mainImage'] ?? "",
        otherImages: List<String>.from(json["otherImages"] ?? []),
      );

  static List<Images> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

class Headings {
  final String shortHeading;
  final String fullHeading;

  Headings({
    required this.fullHeading,
    required this.shortHeading,
  });

  Map<String, dynamic> toJson() => {"fullHeading": fullHeading, "shortHeading": shortHeading};

  static Headings fromJson(Map<String, dynamic> json) =>
      Headings(
        shortHeading: json['shortHeading'] ?? "",
        fullHeading: json["fullHeading"] ?? "",
      );

  static List<Headings> fromMapList(List<dynamic> list) {
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
    "RatingNo": RatingNo,

  };

  static Rating fromJson(Map<String, dynamic> json) => Rating(
    UserId: json['id'] ?? "",
    RatingNo: json['RatingNo'] ?? 0.0,
    
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
  final String id,data;


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

  static List<ReviewsConvertor> fromMapList(
      List<dynamic> list) {
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

class subContactsConvertor {
  final String type;
  final String data;

  subContactsConvertor({
    required this.type,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
    "type": type,
    "data": data,
  };

  static subContactsConvertor fromJson(Map<String, dynamic> json) =>
      subContactsConvertor(
        type: json['type'] ?? "",
        data: json['data'] ?? "",
      );

  static List<subContactsConvertor> fromMapList(List<dynamic> list) {
    return list.map((item) => fromJson(item)).toList();
  }
}

