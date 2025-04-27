<?php

namespace App\Service;

use App\DTO\DreamCreateDTO;
use App\Entity\Actor;
use App\Entity\Dream;
use App\Entity\Location;
use App\Entity\User;
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

    public function create(DreamCreateDTO $dto, User $user): Dream
    {
        $dream = new Dream();
        $dream->setTitle($dto->title);
        $dream->setContent($dto->content);
        $dream->setFeeling($dto->feeling);
        $dream->setUser($user);

        foreach ($dto->actors as $name) {
            $actor = $this->em->getRepository(Actor::class)->findOneBy(['name' => $name]) ?? new Actor();
            if (!$actor->getId()) {
                $actor->setName($name);
                $this->em->persist($actor);
            }
            $dream->addActor($actor);
        }

        foreach ($dto->locations as $name) {
            $location = $this->em->getRepository(Location::class)->findOneBy(['name' => $name]) ?? new Location();
            if (!$location->getId()) {
                $location->setName($name);
                $this->em->persist($location);
            }
            $dream->addLocation($location);
        }

        $this->em->persist($dream);
        $this->em->flush();

        return $dream;
    }
    public function getDreamsByUser(User $user): array
    {
        $dreams = $this->repository->findBy(['user' => $user]);
        return array_map(function (Dream $dream) {
            return new DreamCreateDTO(
                $dream->getTitle(),
                $dream->getContent(),
                $dream->getFeeling(),
                $dream->getActors()->map(fn($actor) => $actor->getName())->toArray(),
                $dream->getLocation()->map(fn($location) => $location->getName())->toArray()
            );
        }, $dreams);
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
