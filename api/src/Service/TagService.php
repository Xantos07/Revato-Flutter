<?php

namespace App\Service;

use App\DTO\DreamCreateDTO;
use App\Entity\Actor;
use App\Entity\Dream;
use App\Entity\Location;
use App\Entity\Tag;
use App\Entity\User;
use App\Repository\TagRepository;
use Doctrine\ORM\EntityManagerInterface;


class TagService
{
    public function __construct(
        private TagRepository $repository,
        private EntityManagerInterface $em,
    ) {}

    public function getAll(): array
    {
        return $this->repository->findAll();
    }

    public function getById(int $id): ?Dream
    {
        return $this->repository->find($id);
    }


    public function getTagsForUser(User $user): array
    {
        $tags = [];

        foreach ($user->getDreams() as $dream) {
            foreach ($dream->getTagsBeforeEvent() as $tag) {
                $tags[$tag->getName()] = $tag;
            }
            foreach ($dream->getTagsBeforeFeeling() as $tag) {
                $tags[$tag->getName()] = $tag;
            }
            foreach ($dream->getTagsDreamFeeling() as $tag) {
                $tags[$tag->getName()] = $tag;
            }
        }

        return array_values($tags);
    }


    public function delete(int $id): bool
    {
        $dream = $this->repository->find($id);
        if (!$dream) return false;

        $this->em->remove($dream);
        $this->em->flush();
        return true;
    }

    public function save(Dream $dream, bool $flush = false): void
    {
        $this->em->persist($dream);
        if ($flush) {
            $this->em->flush();
        }
    }
}
