<?php

namespace App\Service;

use App\DTO\DreamCreateDTO;
use App\Entity\Actor;
use App\Entity\Dream;
use App\Entity\Location;
use App\Entity\Tag;
use App\Entity\User;
use App\Repository\DreamRepository;
use Doctrine\ORM\EntityManagerInterface;
use Psr\Log\LoggerInterface;

class DreamService
{
    public function __construct(
        private DreamRepository $repository,
        private EntityManagerInterface $em,
        private LoggerInterface $logger
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

        $dream->setDate(new \DateTimeImmutable());
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
        foreach ($dto->tagsBeforeEvent as $name) {
            $tag = $this->em->getRepository(Tag::class)->findOneBy(['name' => $name]) ?? new Tag();
            if (!$tag->getId()) {
                $tag->setName($name);
                $this->em->persist($tag);
            }
            $dream->addTagBeforeEvent($tag);
        }

        foreach ($dto->tagsBeforeFeeling as $name) {
            $tag = $this->em->getRepository(Tag::class)->findOneBy(['name' => $name]) ?? new Tag();
            if (!$tag->getId()) {
                $tag->setName($name);
                $this->em->persist($tag);
            }
            $dream->addTagBeforeFeeling($tag);
        }

        foreach ($dto->tagsDreamFeeling as $name) {
            $tag = $this->em->getRepository(Tag::class)->findOneBy(['name' => $name]) ?? new Tag();
            if (!$tag->getId()) {
                $tag->setName($name);
                $this->em->persist($tag);
            }
            $dream->addTagDreamFeeling($tag);
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
                date: $dream->getDate()->format('Y-m-d\TH:i:s'),
                title: $dream->getTitle(),
                content: $dream->getContent(),
                feeling: $dream->getFeeling(),
                actors: $dream->getActors()->map(fn($actor) => $actor->getName())->toArray(),
                locations: $dream->getLocation()->map(fn($location) => $location->getName())->toArray(),
                tagsBeforeEvent: $dream->getTagsBeforeEvent()->map(fn($tagsBeforeEvent) => $tagsBeforeEvent->getName())->toArray(),
                tagsBeforeFeeling: $dream->getTagsBeforeFeeling()->map(fn($tagsBeforeFeeling) => $tagsBeforeFeeling->getName())->toArray(),
                tagsDreamFeeling: $dream->getTagsDreamFeeling()->map(fn($tagsDreamFeeling) => $tagsDreamFeeling->getName())->toArray(),
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
