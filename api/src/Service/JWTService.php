<?php
namespace App\Service;

use DateTimeImmutable;

class JWTService
{
    private string $jwtSecret;

    public function __construct()
    {
        $this->jwtSecret = $_ENV['JWT_SECRET'];
    }

    // On génère le token

    /**
     * Génération du JWT
     * @param array $header
     * @param array $payload
     * @param int $validity
     * @return string
     */
    public function generate(array $header, array $payload, int $validity = 2592000): string
    {

        $now = new DateTimeImmutable();

        if (!isset($payload['iat'])) {
            $payload['iat'] = $now->getTimestamp();
        }

        if (!isset($payload['exp'])) {
            $payload['exp'] = $now->getTimestamp() + $validity;
        }

        // On encode en base64
        $base64Header = base64_encode(json_encode($header));
        $base64Payload = base64_encode(json_encode($payload));

        // On "nettoie" les valeurs encodées (retrait des +, / et =)
        $base64Header = str_replace(['+', '/', '='], ['-', '_', ''], $base64Header);
        $base64Payload = str_replace(['+', '/', '='], ['-', '_', ''], $base64Payload);

        // On génère la signature
        $encodedSecret = base64_encode($this->jwtSecret);
        $signature = hash_hmac('sha256', "$base64Header.$base64Payload", $encodedSecret, true);

        $base64Signature = base64_encode($signature);

        $signature = str_replace(['+', '/', '='], ['-', '_', ''], $base64Signature);

        // On crée le token
        $jwt = $base64Header . '.' . $base64Payload . '.' . $signature;

        return $jwt;
    }

    //On vérifie que le token est valide (correctement formé)
    public function isValid(string $token): bool
    {
        return preg_match(
            '/^[a-zA-Z0-9\-\_\=]+\.[a-zA-Z0-9\-\_\=]+\.[a-zA-Z0-9\-\_\=]+$/',
            $token
        ) === 1;
    }

    // On récupère le Payload
    public function getPayload(string $token): array
    {
        // On démonte le token
        $array = explode('.', $token);

        // On décode le Payload
        $payload = json_decode(base64_decode($array[1]), true);

        return $payload;
    }

    // On récupère le Header
    public function getHeader(string $token): array
    {
        // On démonte le token
        $array = explode('.', $token);

        // On décode le Header
        $header = json_decode(base64_decode($array[0]), true);

        return $header;
    }

    // On vérifie si le token a expiré
    public function isExpired(string $token): bool
    {
        $payload = $this->getPayload($token);

        $now = new DateTimeImmutable();

        return $payload['exp'] <= $now->getTimestamp();
    }

    // On vérifie la signature du Token
    public function check(string $token)
    {
        // On récupère le header et le payload
        $header = $this->getHeader($token);
        $payload = $this->getPayload($token);

        // On régénère un token
        $verifToken = $this->generate($header, $payload, 0);

        return hash_equals($token, $verifToken);
    }
}