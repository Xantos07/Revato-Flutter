<?php

namespace App\Service;

use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class LoginService
{
    public function __construct(
        private EntityManagerInterface $em,
        private UserPasswordHasherInterface $hasher,
        private JWTService $jwt
    ) {}

    public function authenticate(string $email, string $password): array
    {
        $user = $this->em->getRepository(User::class)->findOneBy(['email' => $email]);
        if (!$user || !$this->hasher->isPasswordValid($user, $password)) {
            return ['success' => false, 'message' => 'Identifiants invalides'];
        }

        $payload = [
            'user_id' => $user->getId(),
            'email' => $user->getEmail(),
        ];

        $header = ['alg' => 'HS256', 'typ' => 'JWT'];
        $token = $this->jwt->generate($header, $payload);

        return ['success' => true, 'token' => $token];
    }
}
