typedef StrapiQuery = Map<String, Object?>;

class Strapi {
  static Map<String, dynamic> parseData(Map<String, Object?> response) {
    if (response.containsKey('data')) {
      return parseData(response['data'] as Map<String, Object?>);
    }
    if (response.containsKey('attributes')) {
      final attributes = response['attributes'] as Map;

      final flatten = attributes.map<String, dynamic>((key, value) {
        if (value is Map && value.containsKey('data')) {
          final data = value['data'];
          if (data == null) {
            return MapEntry(key, null);
          } else if (data is List) {
            return MapEntry(key, data.map((item) => parseData(item)).toList());
          } else if (data is Map<String, dynamic>) {
            return MapEntry(key, parseData(data));
          }
        }
        return MapEntry(key, value);
      });
      return {
        'id': response['id'] as int,
        ...flatten,
      };
    }
    return response;
  }

  static List<T> parseList<T>(
    Map<String, Object?> response, {
    required T Function(Map<String, dynamic>) fromJson,
  }) {
    final data = response['data'] as List;
    return data.map((item) {
      return fromJson(parseData(item));
    }).toList();
  }
}
