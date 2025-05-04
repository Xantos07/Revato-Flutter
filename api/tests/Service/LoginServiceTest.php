<?php

namespace App\Tests\Service;
use App\Repository\UserRepository;
use App\Service\JWTService;
use App\Service\LoginService;
use Doctrine\ORM\EntityManagerInterface;
use PHPUnit\Framework\TestCase;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class LoginServiceTest extends TestCase
{
    public function testLoginFailsIfUserNotFound()
    {
        $email = 'test@example.com';
        $password = 'Str0ngP@ssw0rd!';

        $repository = $this->createMock(UserRepository::class);
        $repository->method('findOneBy')->willReturn(null);

        $em = $this->createMock(EntityManagerInterface::class);
        $em->method('getRepository')->willReturn($repository);

        $hasher = $this->createMock(UserPasswordHasherInterface::class);
        $jwt = $this->createMock(JWTService::class);

        $service = new LoginService($em, $hasher, $jwt, 'jwtSecretTest');

        $result = $service->authenticate($email, $password);

        $this->assertEquals(false, $result['success']);
        $this->assertStringContainsString('Identifiants invalides', $result['message']);
    }

}