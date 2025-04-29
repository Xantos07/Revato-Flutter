<?php

namespace App\Controller;

use App\DTO\DreamCreateDTO;
use App\Service\DreamService;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Security\Http\Attribute\IsGranted;
use Symfony\Component\Serializer\Exception\NotEncodableValueException;
use Symfony\Component\Serializer\SerializerInterface;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class DreamController extends AbstractController
{
    #[Route('/api/dreams', name: 'api_dreams', methods: ['GET'])]
    public function list(DreamService $service): JsonResponse
    {
        $user = $this->getUser();
        $dreams = $service->getDreamsByUser($user);
        return $this->json($dreams);
    }
    #[Route('/api/dreams', name: 'api_dreams_create', methods: ['POST'])]
    #[IsGranted('IS_AUTHENTICATED_FULLY')]
    public function create(
        Request             $request,
        SerializerInterface $serializer,
        ValidatorInterface  $validator,
        DreamService        $dreamService,
    ): JsonResponse {

        $user = $this->getUser();

        try {
            $dto = $serializer->deserialize(
                $request->getContent(),
                DreamCreateDTO::class,
                'json'
            );
        } catch (NotEncodableValueException $e) {
            return $this->json(['error' => 'JSON invalide ou mal formé.'], 400);
        }

        // Validation
        $errors = $validator->validate($dto);
        if (count($errors) > 0) {
            return $this->json(['errors' => (string) $errors], 400);
        }

        // Création du rêve
        $dream = $dreamService->create($dto, $user);

        return $this->json([
            'message' => 'Dream created successfully!',
            'id'      => $dream->getId(),
        ], 201);
    }
}
