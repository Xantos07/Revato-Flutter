<?php

namespace App\Tests\Service;

use App\Service\JWTService;
use PHPUnit\Framework\TestCase;

class JWTServiceTest extends TestCase
{
    private JWTService $jwt;
    private string $secret;
    private array $header;
    private array $payload;

    protected function setUp(): void
    {
        $this->jwt = new JWTService();
        $this->secret = 'testSecret';
        $this->header = ['alg' => 'HS256', 'typ' => 'JWT'];
        $this->payload = ['user_id' => 123];
    }

    public function testGenerateReturnsValidJWTStructure()
    {
        $token = $this->jwt->generate($this->header, $this->payload, $this->secret);

        $this->assertIsString($token);
        $this->assertTrue($this->jwt->isValid($token));
        $this->assertCount(3, explode('.', $token));
    }

    public function testPayloadAndHeaderAreCorrectlyDecoded()
    {
        $token = $this->jwt->generate($this->header, $this->payload, $this->secret);

        $decodedHeader = $this->jwt->getHeader($token);
        $decodedPayload = $this->jwt->getPayload($token);

        $this->assertEquals($this->header['alg'], $decodedHeader['alg']);
        $this->assertEquals($this->payload['user_id'], $decodedPayload['user_id']);
        $this->assertArrayHasKey('exp', $decodedPayload);
        $this->assertArrayHasKey('iat', $decodedPayload);
    }

    public function testTokenIsNotExpiredJustAfterGeneration()
    {
        $token = $this->jwt->generate($this->header, $this->payload, $this->secret, 3600);
        $this->assertFalse($this->jwt->isExpired($token));
    }

    public function testTokenIsExpiredIfValidityIsZero()
    {
        $token = $this->jwt->generate($this->header, $this->payload, $this->secret, 0);
        $this->assertTrue($this->jwt->isExpired($token));
    }


    public function testSignatureCheckFailsWithWrongSecret()
    {
        $token = $this->jwt->generate($this->header, $this->payload, $this->secret);
        $this->assertFalse($this->jwt->check($token, 'wrongSecret'));
    }

    public function testTokenFailsFormatCheckWithMalformedToken()
    {
        $this->assertFalse($this->jwt->isValid('invalid.token.without.three.parts'));
        $this->assertFalse($this->jwt->isValid('abc.def'));
    }
}
