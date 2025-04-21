<?php

namespace App\Service;

use App\Entity\Location;
use App\Repository\LocationRepository;

class LocationService
{
    public function __construct(private LocationRepository $repository) {}

    /**
     * @return Location[]
     */
    public function getAllLocations(): array
    {
        return $this->repository->findAll();
    }

    public function createLocation(string $name): Location
    {
        $location = new Location();
        $location->setName($name);

        $this->repository->save($location, true);

        return $location;
    }
}
