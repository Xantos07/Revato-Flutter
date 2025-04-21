<?php

namespace App\Controller;

use App\Dto\DreamCreateDTO;
use App\Entity\Dream;
use App\Entity\Actor;
use App\Entity\Location;
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
        EntityManagerInterface $em
    ): JsonResponse {
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

        $dream = new Dream();
        $dream->setTitle($dto->title);
        $dream->setContent($dto->content);
        $dream->setFeeling($dto->feeling);

        foreach ($dto->actors as $actorName) {
            $actor = $em->getRepository(Actor::class)->findOneBy(['name' => $actorName]) ?? new Actor();
            if (!$actor->getId()) {
                $actor->setName($actorName);
                $em->persist($actor);
            }
            $dream->addActor($actor);
        }

        foreach ($dto->locations as $locationName) {
            $location = $em->getRepository(Location::class)->findOneBy(['name' => $locationName]) ?? new Location();
            if (!$location->getId()) {
                $location->setName($locationName);
                $em->persist($location);
            }
            $dream->addLocation($location);
        }

        $em->persist($dream);
        $em->flush();

        return $this->json(['message' => 'Dream created successfully!', 'id' => $dream->getId()], 201);
    }
}
