<?php

namespace App\DTO;

use Symfony\Component\Validator\Constraints as Assert;

class DreamCreateDTO
{
    #[Assert\NotBlank]
    public string $title;

    #[Assert\NotBlank]
    public string $content;

    #[Assert\NotBlank]
    public string $feeling;

    /** @var string[] */
    #[Assert\Type('array')]
    public array $actors = [];

    /** @var string[] */
    #[Assert\Type('array')]
    public array $locations = [];
}
