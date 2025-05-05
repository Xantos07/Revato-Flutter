<?php

// src/Service/UserRegistrationService.php
namespace App\Service;

use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Validator\Constraints\NotBlank;
use Symfony\Component\Validator\Constraints\PasswordStrength;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use Symfony\Component\Validator\Constraints as Assert;

class RegistrationService
{
    private $em;
    private $passwordHasher;
    private $validator;
    private $jwt;

    public function __construct(EntityManagerInterface $em,
                                UserPasswordHasherInterface $passwordHasher,
                                ValidatorInterface $validator,
                                JWTService $jwt)
    {
        $this->em = $em;
        $this->passwordHasher = $passwordHasher;
        $this->validator = $validator;
        $this->jwt = $jwt;
    }


    public function register(string $email, string $plainPassword): array
    {
        // Validation
        $errors = $this->validator->validate(
            ['email' => $email, 'password' => $plainPassword],
            new Assert\Collection([
                'email' => [
                    new Assert\NotBlank(),
                    new Assert\Email(),
                ],
                'password' => [
                    new NotBlank(),
                    new PasswordStrength([
                        'minScore' => PasswordStrength::STRENGTH_MEDIUM,
                        'message' => 'Le mot de passe est trop faible.',
                    ]),
                    new Assert\Length(min: 7)
                ]
            ])
        );

        if (count($errors) > 0) {
            return ['error' => (string) $errors, 'code' => 400];
        }

        if ($this->em->getRepository(User::class)->findOneBy(['email' => $email])) {
            return ['success' => false, 'error' => 'Email déjà utilisé', 'code' => 409];
        }

        $user = new User();
        $user->setEmail($email);
        $user->setPassword($this->passwordHasher->hashPassword($user, $plainPassword));
        $this->em->persist($user);
        $this->em->flush();

        $payload = [
            'user_id' => $user->getId(),
            'email' => $user->getEmail(),
        ];

        $header = ['alg' => 'HS256', 'typ' => 'JWT'];
        $token = $this->jwt->generate($header, $payload);

        return ['success' => true,'token' => $token, 'code' => 201];
    }
}
