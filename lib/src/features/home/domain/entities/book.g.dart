
part of 'book.dart';


Book _$BookFromJson(Map<String, dynamic> json) => Book(
  id: json['id'] as String,
  title: json['title'] as String,
  author: json['author'] as String,
  pageCount: (json['pageCount'] as num).toInt(),
  isReading: json['isReading'] as bool? ?? false,
);

Map<String, dynamic> _$BookToJson(Book instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'author': instance.author,
  'pageCount': instance.pageCount,
  'isReading': instance.isReading,
};
