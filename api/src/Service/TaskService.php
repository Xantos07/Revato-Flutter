<?php

namespace App\Service;

use App\DTO\TaskDTO;
use App\Entity\Task;
use App\Repository\TaskRepository;

class TaskService
{
    public function __construct(private TaskRepository $repository) {}

    public function getAllTasks(): array
    {
        $tasks = $this->repository->findAll();

        return array_map(function (Task $task) {
            return new TaskDTO(
                $task->getId(),
                $task->getTitle(),
                $task->isDone()
            );
        }, $tasks);
    }
}
