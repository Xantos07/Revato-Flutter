<?php

namespace App\DTO;


# Pour exposer uniquement les champs qu’on veut montrer au frontend
# Éviter d'exposer directement l'entité Doctrine
class TaskDTO
{
    public int $id;
    public string $title;
    public bool $done;

    public function __construct(int $id, string $title, bool $done)
    {
        $this->id = $id;
        $this->title = $title;
        $this->done = $done;
    }
}
