<?php

namespace App\Controller;

use App\Service\TaskService;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\Routing\Annotation\Route;

class TaskController extends AbstractController
{
    #[Route('/api/tasks', name: 'api_tasks', methods: ['GET'])]
    public function list(TaskService $service): JsonResponse
    {
        $tasks = $service->getAllTasks();
        return $this->json($tasks);
    }
}
