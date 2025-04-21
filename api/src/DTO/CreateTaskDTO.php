<?php

namespace App\DTO;

use Symfony\Component\Validator\Constraints as Assert;

class CreateTaskDTO
{
    #[Assert\NotBlank]
    #[Assert\Length(max: 255)]
    public string $title;

    #[Assert\Type('bool')]
    public bool $done = false;
}
