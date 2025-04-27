<?php

use App\Entity\User;
use App\Service\JWTService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;

class LoginService
{
    public function __construct(
        private EntityManagerInterface $em,
        private UserPasswordHasherInterface $hasher,
        private JWTService $jwt,
        private string $jwtSecret
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

        $token = $this->jwt->generate(['typ' => 'JWT', 'alg' => 'HS256'], $payload, $this->jwtSecret);

        $user->setApiToken($token);
        $this->em->flush();

        return ['success' => true, 'token' => $token];
    }
}
