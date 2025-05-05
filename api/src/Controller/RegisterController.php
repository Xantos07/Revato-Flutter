<?php

namespace App\Controller;

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
        RegistrationService $registrationService
    ): JsonResponse {

        $data = json_decode($request->getContent(), true);

        $result = $registrationService->register($data['email'], $data['password']);

        if (!$result['success']) {
            return $this->json(['error' => $result['error']], $result['code']);
        }


        return $this->json([
            'message' => 'Utilisateur créé avec succès',
            'token' => $result['token'],
        ], 201);

    }
}
