<?php

namespace App\Tests\Service;

use App\Entity\User;
use Doctrine\ORM\EntityRepository;
use PHPUnit\Framework\TestCase;
use App\Service\RegistrationService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Validator\ConstraintViolation;
use Symfony\Component\Validator\Validator\ValidatorInterface;
use Symfony\Component\Validator\ConstraintViolationList;


class RegistrationServiceTest extends TestCase
{
    public function testRegisterFailsIfEmailAlreadyExists()
    {
        $email = 'test@example.com';
        $password = '1234';

        // Mock repository
        $userMock = $this->createMock(User::class);

        $repository = $this->createMock(EntityRepository::class);
        $repository->expects($this->once())
            ->method('findOneBy')
            ->willReturn($userMock);

        $em = $this->createMock(EntityManagerInterface::class);
        $em->expects($this->once())
            ->method('getRepository')
            ->willReturn($repository);


        $hasher = $this->createMock(UserPasswordHasherInterface::class);
        $validator = $this->createMock(ValidatorInterface::class);
        $validator->expects($this->once())->method('validate')->willReturn(new ConstraintViolationList());

        $service = new RegistrationService($em, $hasher, $validator);

        $result = $service->register($email, $password);

        $this->assertArrayHasKey('error', $result);
        $this->assertEquals(409, $result['code']);
    }

    public function testRegisterFailsIfEmailInvalid()
    {
        $email = 'pas-un-email';
        $password = '1234';

        $em = $this->createMock(EntityManagerInterface::class);

        $hasher = $this->createMock(UserPasswordHasherInterface::class);

        // Simule un échec de validation
        $violationList = new ConstraintViolationList([new ConstraintViolation(
            'Invalid email', null, [], '', 'email', 'pas-un-email'
        )]);
        $validator = $this->createMock(ValidatorInterface::class);
        $validator->expects($this->once())->method('validate')->willReturn($violationList);

        $service = new RegistrationService($em, $hasher, $validator);

        $result = $service->register($email, $password);

        $this->assertArrayHasKey('error', $result);
        $this->assertEquals(400, $result['code']);
    }

    public function testRegisterFailsIfPasswordTooShort()
    {
        $email = 'test@example.com';
        $password = '12'; // trop court

        $em = $this->createMock(EntityManagerInterface::class);

        $hasher = $this->createMock(UserPasswordHasherInterface::class);

        $violationList = new ConstraintViolationList([new ConstraintViolation(
            'Password too short', null, [], '', 'password', '12'
        )]);
        $validator = $this->createMock(ValidatorInterface::class);
        $validator->expects($this->once())->method('validate')->willReturn($violationList);

        $service = new RegistrationService($em, $hasher, $validator);

        $result = $service->register($email, $password);

        $this->assertArrayHasKey('error', $result);
        $this->assertEquals(400, $result['code']);
    }


    public function testRegisterSuccess()
    {
        // Arrange
        $email = 'test@example.com';
        $password = '1234';

        $repository = $this->createMock(EntityRepository::class);
        $repository->expects($this->once())
            ->method('findOneBy')
            ->willReturn(null);

        $em = $this->createMock(EntityManagerInterface::class);
        $em->expects($this->once())
            ->method('getRepository')
            ->willReturn($repository);

        $em->expects($this->once())->method('persist');
        $em->expects($this->once())->method('flush');

        $hasher = $this->createMock(UserPasswordHasherInterface::class);
        $hasher->expects($this->once())->method('hashPassword')->willReturn('hashed');

        $validator = $this->createMock(ValidatorInterface::class);
        $validator->expects($this->once())->method('validate')->willReturn(new ConstraintViolationList());

        $service = new RegistrationService($em, $hasher, $validator);

        // Act
        $result = $service->register($email, $password);

        // Assert
        $this->assertArrayHasKey('user', $result);
        $this->assertEquals(201, $result['code']);
        $this->assertEquals($email, $result['user']->getEmail());
        $this->assertEquals('hashed', $result['user']->getPassword());
    }
}
