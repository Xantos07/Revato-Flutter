<?php

namespace App\Controller;

use App\DTO\AuthenticationDTO;
use App\Service\LoginService;

use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Serializer\Exception\NotEncodableValueException;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\Validator\Validator\ValidatorInterface;

class LoginController extends AbstractController
{
    #[Route('/api/login', name: 'api_login', methods: ['POST'])]
    public function login(Request $request,
                          LoginService $loginService,
                          SerializerInterface $serializer,
                          ValidatorInterface $validator): JsonResponse
    {

        try {
            $dto = $serializer->deserialize(
                $request->getContent(),
                AuthenticationDTO::class,
                'json'
            );
        } catch (NotEncodableValueException $e) {
            return $this->json(['error' => 'JSON invalide ou mal formé.'], 400);
        }

        // Validation du DTO
        $errors = $validator->validate($dto);
        if (count($errors) > 0) {
            $messages = [];
            foreach ($errors as $violation) {
                $messages[$violation->getPropertyPath()] = $violation->getMessage();
            }
            return $this->json(['errors' => $messages], 400);
        }
        // Récupération des données depuis le DTO
        $email    = $dto->email;
        $password = $dto->password;

        $result = $loginService->authenticate($email, $password);

        if (!$result['success']) {
            return $this->json(['error' => $result['message']], 401);
        }

        return $this->json(['token' => $result['token']]);
    }

}
