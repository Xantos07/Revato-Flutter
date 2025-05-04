<?php

namespace App\Controller;

use App\Service\LoginService;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class LoginController extends AbstractController
{
    #[Route('/api/login', name: 'api_login', methods: ['POST'])]
    public function login(Request $request, LoginService $loginService): JsonResponse
    {
        $data = json_decode($request->getContent(), true);

        if (!isset($data['email'], $data['password'])) {
            return $this->json(['error' => 'Email ou mot de passe manquant'], 400);
        }

        $result = $loginService->authenticate($data['email'], $data['password']);

        if (!$result['success']) {
            return $this->json(['error' => $result['message']], 401);
        }

        return $this->json(['token' => $result['token']]);
    }

}
