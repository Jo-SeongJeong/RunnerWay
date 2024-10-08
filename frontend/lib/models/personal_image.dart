class PersonalImage {
  final String? url;

  PersonalImage({
    this.url,
  });

  factory PersonalImage.fromJson(Map<String, dynamic> json) {
    return PersonalImage(
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url ?? '',
    };
  }

  @override
  String toString() {
    return 'PersonalImage(url: $url)';
  }
}
