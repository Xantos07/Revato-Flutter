<?php

namespace App\Controller;

use App\Entity\User;
use App\Service\JWTService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class LoginController extends AbstractController
{
    #[Route('/api/login', name: 'api_login', methods: ['POST'])]
    public function login(
        Request $request,
        EntityManagerInterface $em,
        UserPasswordHasherInterface $hasher,
        JWTService $jwt
    ): JsonResponse {
        $data = json_decode($request->getContent(), true);

        $user = $em->getRepository(User::class)->findOneBy(['email' => $data['email']]);

        if (!$user || !$hasher->isPasswordValid($user, $data['password'])) {
            return $this->json(['error' => 'Identifiants invalides'], 401);
        }

        // Générer le token
        $header = [
            'typ' => 'JWT',
            'alg' => 'HS256',
        ];

        $payload = [
            'user_id' => $user->getId(),
            'email' => $user->getEmail(),
        ];

        $token = $jwt->generate($header, $payload, $this->getParameter('app.jwtsecret'));

        return $this->json([
            'token' => $token,
        ]);
    }
}
