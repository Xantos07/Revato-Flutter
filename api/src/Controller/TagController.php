<?php

namespace App\Controller;


use App\Service\TagService;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;

class TagController extends AbstractController
{
    #[Route('/api/tags', name: 'api_tags', methods: ['GET'])]
    public function list(TagService $tagService): JsonResponse
    {
        $user = $this->getUser();
        $tags = $tagService->getTagsForUser($user);

        return $this->json($tags, 200, [], ['groups' => ['tag:read']]);
    }
}
