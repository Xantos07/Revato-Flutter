<?php

namespace App\Controller;

use App\DTO\AuthenticationDTO;
use App\Service\RegistrationService;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\Serializer\Exception\NotEncodableValueException;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\Validator\Validator\ValidatorInterface;

class RegisterController extends AbstractController
{
    #[Route('/api/register', name: 'api_register', methods: ['POST'])]
    public function register(
        Request $request,
        RegistrationService $registrationService,
        SerializerInterface $serializer,
        ValidatorInterface $validator
    ): JsonResponse {

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

        $result = $registrationService->register($email, $password);

        if (!$result['success']) {
            return $this->json(['error' => $result['error']], $result['code']);
        }


        return $this->json([
            'message' => 'Utilisateur créé avec succès',
            'token' => $result['token'],
        ], 201);

    }
}
