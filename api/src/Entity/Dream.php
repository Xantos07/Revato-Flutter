<?php

namespace App\Entity;

use App\Repository\DreamRepository;
use Doctrine\Common\Collections\ArrayCollection;
use Doctrine\Common\Collections\Collection;
use Doctrine\DBAL\Types\Types;
use Doctrine\ORM\Mapping as ORM;

#[ORM\Entity(repositoryClass: DreamRepository::class)]
class Dream
{
    #[ORM\Id]
    #[ORM\GeneratedValue]
    #[ORM\Column]
    private ?int $id = null;

    #[ORM\Column(type: 'datetime')]
    private \DateTimeInterface $date;
    #[ORM\Column(length: 255)]
    private ?string $title = null;

    #[ORM\Column(type: Types::TEXT)]
    private ?string $content = null;

    #[ORM\Column(type: Types::TEXT)]
    private ?string $feeling = null;

    #[ORM\ManyToOne(targetEntity: User::class, inversedBy: 'dreams', cascade: ['persist'])]
    private ?User $user = null;
    #[ORM\ManyToMany(targetEntity: Actor::class, inversedBy: 'dreams')]
    private Collection $actors;

    #[ORM\ManyToMany(targetEntity: Location::class, inversedBy: 'dreams')]
    private Collection $locations;

    #[ORM\ManyToMany(targetEntity: Tag::class, cascade: ['persist'])]
    #[ORM\JoinTable(name: "dream_tags_before_event")]
    private Collection $tagsBeforeEvent;

    #[ORM\ManyToMany(targetEntity: Tag::class, cascade: ['persist'])]
    #[ORM\JoinTable(name: "dream_tags_before_feeling")]
    private Collection $tagsBeforeFeeling;

    #[ORM\ManyToMany(targetEntity: Tag::class, cascade: ['persist'])]
    #[ORM\JoinTable(name: "dream_tags_dream_feeling")]
    private Collection $tagsDreamFeeling;




    public function __construct()
    {
        $this->actors = new ArrayCollection();
        $this->locations = new ArrayCollection();
        $this->tagsBeforeEvent = new ArrayCollection();
        $this->tagsBeforeFeeling = new ArrayCollection();
        $this->tagsDreamFeeling = new ArrayCollection();
    }
    public function getDate(): \DateTimeInterface
    {
        return $this->date;
    }

    public function setDate(\DateTimeInterface $date): self
    {
        $this->date = $date;
        return $this;
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

    public function getUser(): ?User
    {
        return $this->user;
    }

    public function setUser(?User $user): static
    {
        $this->user = $user;
        return $this;
    }
    public function getTagsBeforeEvent(): Collection
    {
        return $this->tagsBeforeEvent;
    }

    public function addTagBeforeEvent(Tag $tag): self
    {
        if (!$this->tagsBeforeEvent->contains($tag)) {
            $this->tagsBeforeEvent[] = $tag;
        }

        return $this;
    }

    public function removeTagBeforeEvent(Tag $tag): self
    {
        $this->tagsBeforeEvent->removeElement($tag);
        return $this;
    }


    public function getTagsBeforeFeeling(): Collection
    {
        return $this->tagsBeforeFeeling;
    }

    public function addTagBeforeFeeling(Tag $tag): self
    {
        if (!$this->tagsBeforeFeeling->contains($tag)) {
            $this->tagsBeforeFeeling[] = $tag;
        }

        return $this;
    }

    public function removeTagBeforeFeeling(Tag $tag): self
    {
        $this->tagsBeforeFeeling->removeElement($tag);
        return $this;
    }


    public function getTagDreamFeeling(): Collection
    {
        return $this->tagsDreamFeeling;
    }

    public function addTagDreamFeeling(Tag $tag): self
    {
        if (!$this->tagsDreamFeeling->contains($tag)) {
            $this->tagsDreamFeeling[] = $tag;
        }

        return $this;
    }

    public function removeTagDreamFeeling(Tag $tag): self
    {
        $this->tagsDreamFeeling->removeElement($tag);
        return $this;
    }

}
