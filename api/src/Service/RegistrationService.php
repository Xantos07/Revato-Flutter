<?php

// src/Service/UserRegistrationService.php
namespace App\Service;

use App\Entity\User;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use Symfony\Component\Validator\Constraints as Assert;

class RegistrationService
{
    private $em;
    private $passwordHasher;
    private $validator;

    public function __construct(EntityManagerInterface $em, UserPasswordHasherInterface $passwordHasher, ValidatorInterface $validator)
    {
        $this->em = $em;
        $this->passwordHasher = $passwordHasher;
        $this->validator = $validator;
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
                'password' => new Assert\Length(min: 4),
            ])
        );
        if (count($errors) > 0) {
            return ['error' => (string) $errors, 'code' => 400];
        }

        if ($this->em->getRepository(User::class)->findOneBy(['email' => $email])) {
            return ['error' => 'Email déjà utilisé', 'code' => 409];
        }

        $user = new User();
        $user->setEmail($email);
        $user->setPassword($this->passwordHasher->hashPassword($user, $plainPassword));
        $this->em->persist($user);
        $this->em->flush();

        return ['user' => $user, 'code' => 201];
    }
}
