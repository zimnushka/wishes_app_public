class PreviewMetaData {
  final String? title;
  final String? description;
  final String? imageUrl;

  const PreviewMetaData({
    this.title,
    this.description,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'image_url': imageUrl,
    };
  }

  factory PreviewMetaData.fromJson(Map<String, dynamic> map) {
    return PreviewMetaData(
      title: map['title'] != null ? map['title'] as String : null,
      description: map['description'] != null ? map['description'] as String : null,
      imageUrl: map['image_url'] != null ? map['image_url'] as String : null,
    );
  }

  PreviewMetaData copyWith({
    String? title,
    String? description,
    String? imageUrl,
  }) {
    return PreviewMetaData(
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
