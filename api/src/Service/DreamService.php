<?php

namespace App\Service;

use App\Entity\Dream;
use App\Repository\DreamRepository;
use Doctrine\ORM\EntityManagerInterface;

class DreamService
{
    public function __construct(
        private DreamRepository $repository,
        private EntityManagerInterface $em
    ) {}

    public function getAll(): array
    {
        return $this->repository->findAll();
    }

    public function getById(int $id): ?Dream
    {
        return $this->repository->find($id);
    }

    public function create(string $title, string $content, string $feeling): Dream
    {
        $dream = new Dream();
        $dream->setTitle($title);
        $dream->setContent($content);
        $dream->setFeeling($feeling);

        $this->em->persist($dream);
        $this->em->flush();

        return $dream;
    }

    public function delete(int $id): bool
    {
        $dream = $this->repository->find($id);
        if (!$dream) return false;

        $this->em->remove($dream);
        $this->em->flush();
        return true;
    }
}
