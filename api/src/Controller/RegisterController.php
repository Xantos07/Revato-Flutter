<?php

namespace App\Controller;

use App\Entity\User;
use App\Service\JWTService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Validator\Constraints as Assert;

class RegisterController extends AbstractController
{
    #[Route('/api/register', name: 'api_register', methods: ['POST'])]
    public function register(
        Request $request,
        EntityManagerInterface $em,
        UserPasswordHasherInterface $passwordHasher,
        ValidatorInterface $validator,
        JWTService $jwt
    ): JsonResponse {
        $data = json_decode($request->getContent(), true);

        $email = $data['email'] ?? null;
        $password = $data['password'] ?? null;

        // Validation
        $errors = $validator->validate(
            ['email' => $email, 'password' => $password],
            new Assert\Collection([
                'email' => [
                    new Assert\NotBlank(),
                    new Assert\Email(),
                ],
                'password' => new Assert\Length(min: 4),
            ])
        );

        if (count($errors) > 0) {
            return $this->json(['errors' => (string) $errors], 400);
        }

        // Vérifier si l'email est déjà utilisé
        if ($em->getRepository(User::class)->findOneBy(['email' => $email])) {
            return $this->json(['error' => 'Email déjà utilisé'], 409);
        }

        // 1. Création utilisateur, persist en base pour générer l'id
        $user = new User();
        $user->setEmail($email);
        $user->setPassword($passwordHasher->hashPassword($user, $password));
        $em->persist($user);
        $em->flush();

        // 2. Génère le JWT AVEC le bon id
        $header = ['alg' => 'HS256', 'typ' => 'JWT'];
        $payload = ['user_id' => $user->getId()];
        $token = $jwt->generate($header, $payload);

        $user->setApiToken($token);
        $em->flush();



        return $this->json([
            'message' => 'Utilisateur créé avec succès',
            'token' => $token,
        ], 201);
    }

}
