<?php

namespace App\Controller;

use App\Entity\Actor;
use App\Entity\Dream;
use App\Entity\Location;
use App\Service\DreamService;
use App\Repository\ActorRepository;
use App\Repository\LocationRepository;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Log\LoggerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Routing\Annotation\Route;

class DreamController extends AbstractController
{
    #[Route('/api/dreams', name: 'api_dreams_list', methods: ['GET'])]
    public function index(DreamService $dreamService): JsonResponse
    {
        $dreams = $dreamService->getAll();

        return $this->json($dreams);
    }

    #[Route('/api/dreams', name: 'api_dreams_create', methods: ['POST'])]
    public function create(
        Request $request,
        DreamService $dreamService,
        ActorRepository $actorRepo,
        LocationRepository $locationRepo,
        EntityManagerInterface $em,
        LoggerInterface $logger
    ): JsonResponse {

        $data = json_decode($request->getContent(), true);
        if ($data === null && json_last_error() !== JSON_ERROR_NONE) {
            return new JsonResponse([
                'error' => 'Erreur de décodage JSON : ' . json_last_error_msg(),
            ], 400);
        }

        $dream = new Dream();
        $dream->setTitle($data['title'] ?? '');
        $dream->setContent($data['content'] ?? '');
        $dream->setFeeling($data['feeling'] ?? '');

        // 👥 ACTORS (par nom)
        foreach ($data['actors'] ?? [] as $actorName) {
            $actor = $actorRepo->findOneBy(['name' => $actorName]);
            if (!$actor) {
                $actor = new Actor();
                $actor->setName($actorName);
                $em->persist($actor);
            }
            $dream->addActor($actor);
        }

        // 📍 LOCATIONS (par nom)
        foreach ($data['locations'] ?? [] as $locationName) {
            $location = $locationRepo->findOneBy(['name' => $locationName]);
            if (!$location) {
                $location = new Location();
                $location->setName($locationName);
                $em->persist($location);
            }
            $dream->addLocation($location);
        }

        $dreamService->save($dream, true);

        return $this->json([
            'message' => 'Dream successfully created!',
            'id' => $dream->getId()
        ], 201);
    }
}
