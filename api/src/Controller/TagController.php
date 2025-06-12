<?php

namespace App\Controller;


use App\Repository\TagRepository;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
class TagController extends AbstractController
{
    #[Route('/api/tags', name: 'api_tags_list', methods: ['GET'])]
    public function listTags(Request $request, TagRepository $repo): JsonResponse
    {
        $page = max((int)$request->query->get('page', 1), 1);
        $pageSize = min((int)$request->query->get('pageSize', 3), 100);
        $category = $request->query->get('category');

        $search = $request->query->get('search');

        $tags = $repo->findPaginated($page, $pageSize, $category, $search);

        $total = count($tags);

        return $this->json([
            'tags' => array_map(fn($t) => [
                'name' => $t->getName(),
                'category' => $t->getCategory()
            ], $tags),
            'total' => $total,
            'page' => $page,
            'pageSize' => $pageSize,
            'totalPages' => ceil($total / $pageSize),
        ]);
    }


    /*
    #[Route('/api/tags', name: 'api_tags', methods: ['GET'])]
    public function list(TagService $tagService): JsonResponse
    {
        $user = $this->getUser();
        $tags = $tagService->getTagsForUser($user);

        return $this->json($tags, 200, [], ['groups' => ['tag:read']]);
    }*/
}
