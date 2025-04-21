<?php

namespace App\Service;

use App\Entity\Actor;
use App\Repository\ActorRepository;

class ActorService
{
    public function __construct(private ActorRepository $repository) {}

    /**
     * @return Actor[]
     */
    public function getAllActors(): array
    {
        return $this->repository->findAll();
    }

    public function createActor(string $name): Actor
    {
        $actor = new Actor();
        $actor->setName($name);

        $this->repository->save($actor, true);

        return $actor;
    }


}
