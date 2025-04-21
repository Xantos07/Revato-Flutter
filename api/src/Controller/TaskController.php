<?php

namespace App\Controller;

use App\Service\TaskService;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use Symfony\Component\Routing\Annotation\Route;
use App\DTO\CreateTaskDTO;

class TaskController extends AbstractController
{
    #[Route('/api/tasks', name: 'api_tasks', methods: ['GET'])]
    public function list(TaskService $service): JsonResponse
    {
        $tasks = $service->getAllTasks();
        return $this->json($tasks);
    }

    #[Route('/api/tasks', name: 'api_tasks_create', methods: ['POST'])]
    public function create(
        Request $request,
        TaskService $service,
        ValidatorInterface $validator
    ): JsonResponse {
        $data = json_decode($request->getContent(), true);

        $dto = new CreateTaskDTO();
        $dto->title = $data['title'] ?? '';
        $dto->done = $data['done'] ?? false;

        $errors = $validator->validate($dto);
        if (count($errors) > 0) {
            return $this->json(['errors' => (string) $errors], 400);
        }

        $task = $service->createTask($dto);

        return $this->json([
            'message' => 'Tâche créée avec succès',
            'id' => $task->getId(),
            'title' => $task->getTitle(),
            'done' => $task->isDone(),
        ], 201);
    }

}
