<?php

namespace App\Controller;

use App\Entity\User;
use App\Service\JWTService;
use App\Service\RegistrationService;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;

use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;


class RegisterController extends AbstractController
{
    #[Route('/api/register', name: 'api_register', methods: ['POST'])]
    public function register(
        Request $request,
        RegistrationService $registrationService,
        JWTService $jwt
    ): JsonResponse {
        $data = json_decode($request->getContent(), true);
        $email = $data['email'] ?? null;
        $password = $data['password'] ?? null;

        $result = $registrationService->register($email, $password);

        if (isset($result['error'])) {
            return $this->json(['error' => $result['error']], $result['code']);
        }

        /** @var User $user */
        $user = $result['user'];

        // 2. Génère le JWT AVEC le bon id
        $header = ['alg' => 'HS256', 'typ' => 'JWT'];
        $payload = ['user_id' => $user->getId()];
        $token = $jwt->generate($header, $payload, $this->getParameter('app.jwtsecret'));

        $user->setApiToken($token);
        $this->getDoctrine()->getManager()->flush();

        return $this->json([
            'message' => 'Utilisateur créé avec succès',
            'token' => $token,
        ], 201);
    }
}
