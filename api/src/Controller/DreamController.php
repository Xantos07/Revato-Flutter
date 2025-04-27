<?php

namespace App\Controller;

use App\DTO\DreamCreateDTO;
use App\Entity\Dream;
use App\Entity\Actor;
use App\Entity\Location;
use App\Repository\UserRepository;
use App\Service\DreamService;
use App\Service\JWTService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Serializer\Exception\NotEncodableValueException;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class DreamController extends AbstractController
{
    #[Route('/api/dreams', name: 'api_dreams_create', methods: ['POST'])]
    public function create(
        Request $request,
        SerializerInterface $serializer,
        ValidatorInterface $validator,
        DreamService $dreamService,
        JWTService $jwtService,
        UserRepository $userRepo
    ): JsonResponse {

        $authHeader = $request->headers->get('Authorization');

        if (!$authHeader || !str_starts_with($authHeader, 'Bearer ')) {
            return $this->json(['error' => 'Token JWT manquant.'], 401);
        }

        $token = substr($authHeader, 7);

        if (!$jwtService->isValid($token) || $jwtService->isExpired($token)) {
            return $this->json(['error' => 'Token JWT invalide ou expiré.'], 401);
        }

        $payload = $jwtService->getPayload($token);
        $userId = $payload['user_id'] ?? null;

        if (!$userId || !($user = $userRepo->find($userId))) {
            return $this->json(['error' => 'Utilisateur introuvable.'], 404);
        }

        try {
            $dto = $serializer->deserialize($request->getContent(), DreamCreateDTO::class, 'json');
        } catch (NotEncodableValueException $e) {
            return $this->json(['error' => 'JSON invalide ou mal encodé.'], 400);
        }

        if ($dto === null) {
            return $this->json(['error' => 'Impossible de désérialiser le contenu'], 400);
        }

        $errors = $validator->validate($dto);
        if (count($errors) > 0) {
            return $this->json(['errors' => (string) $errors], 400);
        }


        $dream = $dreamService->create($dto, $user);

        return $this->json(['message' => 'Dream created successfully!', 'id' => $dream->getId()], 201);
    }
}
