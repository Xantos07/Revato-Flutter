<?php

namespace App\Service;

use App\DTO\CreateTaskDTO;
use App\DTO\TaskDTO;
use App\Entity\Task;
use App\Repository\TaskRepository;
use Doctrine\ORM\EntityManagerInterface;
class TaskService
{
    public function __construct(
        private TaskRepository $repository,
        private EntityManagerInterface $em
    ) {}

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
    public function createTask(CreateTaskDTO $dto): Task
    {
        $task = new Task();
        $task->setTitle($dto->title);
        $task->setDone($dto->done);

        $this->em->persist($task);
        $this->em->flush();

        return $task;
    }

}
