<?php

namespace App\Entity;

use App\Repository\DreamRepository;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: DreamRepository::class)]
class Dream
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(length: 255)]
    private ?string $title = null;

    #[ORM\Column(type: Types::TEXT)]
    private ?string $content = null;

    #[ORM\Column(type: Types::TEXT)]
    private ?string $feeling = null;

    #[ORM\ManyToMany(targetEntity: Actor::class, inversedBy: 'dreams')]
    private Collection $actors;

    #[ORM\ManyToMany(targetEntity: Location::class, inversedBy: 'dreams')]
    private Collection $locations;

    public function __construct()
    {
        $this->actors = new ArrayCollection();
        $this->locations = new ArrayCollection();
    }

    public function getId(): ?int
    {
        return $this->id;
    }

    public function getTitle(): ?string
    {
        return $this->title;
    }

    public function setTitle(string $title): static
    {
        $this->title = $title;

        return $this;
    }

    public function getContent(): ?string
    {
        return $this->content;
    }

    public function setContent(string $content): static
    {
        $this->content = $content;

        return $this;
    }

    public function getFeeling(): ?string
    {
        return $this->feeling;
    }

    public function setFeeling(string $feeling): static
    {
        $this->feeling = $feeling;

        return $this;
    }

    public function getActors(): Collection
    {
        return $this->actors;
    }

    public function addActor(Actor $actor): self
    {
        if (!$this->actors->contains($actor)) {
            $this->actors[] = $actor;
        }
        return $this;
    }

    public function removeActor(Actor $actor): self
    {
        $this->actors->removeElement($actor);
        return $this;
    }

    public function getLocation(): Collection
    {
        return $this->locations;
    }

    public function addLocation(Location $location): self
    {
        if (!$this->locations->contains($location)) {
            $this->locations[] = $location;
        }

        return $this;
    }

    public function removeLocation(Location $location): self
    {
        $this->locations->removeElement($location);
        return $this;
    }
}
