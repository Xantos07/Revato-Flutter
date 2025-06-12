<?php

namespace App\Repository;

use App\Entity\Dream;
use App\Entity\User;
use Doctrine\Bundle\DoctrineBundle\Repository\ServiceEntityRepository;
use Doctrine\Persistence\ManagerRegistry;

/**
 * @extends ServiceEntityRepository<Dream>
 */
class DreamRepository extends ServiceEntityRepository
{
    public function __construct(ManagerRegistry $registry)
    {
        parent::__construct($registry, Dream::class);
    }
    public function countByUserAndDateRangeAndTags(User $user, ?string $startDate, ?string $endDate, array $tags = []): int
    {
        $qb = $this->createQueryBuilder('d')
            ->select('COUNT(d.id)')
            ->where('d.user = :user')
            ->setParameter('user', $user);

        if ($startDate) {
            $qb->andWhere('d.date >= :startDate')
                ->setParameter('startDate', new \DateTime($startDate));
        }

        if ($endDate) {
            $qb->andWhere('d.date <= :endDate')
                ->setParameter('endDate', new \DateTime($endDate));
        }

        if (!empty($tags)) {
            $qb->leftJoin('d.tagsBeforeEvent', 'tbe')
                ->leftJoin('d.tagsBeforeFeeling', 'tbf')
                ->leftJoin('d.tagsDreamFeeling', 'tdf')
                ->andWhere(
                    $qb->expr()->orX(
                        'tbe.name IN (:tags)',
                        'tbf.name IN (:tags)',
                        'tdf.name IN (:tags)'
                    )
                )
                ->setParameter('tags', $tags);
        }


        return (int) $qb->getQuery()->getSingleScalarResult();
    }

    //    /**
    //     * @return Dream[] Returns an array of Dream objects
    //     */
    //    public function findByExampleField($value): array
    //    {
    //        return $this->createQueryBuilder('d')
    //            ->andWhere('d.exampleField = :val')
    //            ->setParameter('val', $value)
    //            ->orderBy('d.id', 'ASC')
    //            ->setMaxResults(10)
    //            ->getQuery()
    //            ->getResult()
    //        ;
    //    }

    //    public function findOneBySomeField($value): ?Dream
    //    {
    //        return $this->createQueryBuilder('d')
    //            ->andWhere('d.exampleField = :val')
    //            ->setParameter('val', $value)
    //            ->getQuery()
    //            ->getOneOrNullResult()
    //        ;
    //    }
}
