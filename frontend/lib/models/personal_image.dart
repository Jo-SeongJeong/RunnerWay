class PersonalImage {
  final String? url;
  final String? path;

  PersonalImage({
    this.url,
    this.path,
  });

  factory PersonalImage.fromJson(Map<String, dynamic> json) {
    return PersonalImage(
      url: json['url'],
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'path': path,
    };
  }

  @override
  String toString() {
    return 'PersonalImage(url: $url, path: $path)';
  }
}
