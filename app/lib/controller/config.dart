const bool isProd = bool.fromEnvironment('dart.vm.product');

final String API_BASE_URL = isProd
    ? 'https://revato.ovh'
    : 'http://localhost:8000';
