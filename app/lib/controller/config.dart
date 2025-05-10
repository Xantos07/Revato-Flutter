const bool isProd = bool.fromEnvironment('dart.vm.product');

final String API_BASE_URL = isProd
    ? 'http://185.157.247.17'
    : 'http://185.157.247.17'; //'http://localhost:8000';
