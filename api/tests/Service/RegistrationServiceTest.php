<?php

namespace App\Tests\Service;

use App\Entity\User;
use App\Service\JWTService;
use Doctrine\ORM\EntityRepository;
use PHPUnit\Framework\TestCase;
use App\Service\RegistrationService;
use Doctrine\ORM\EntityManagerInterface;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Validator\Validation;

class RegistrationServiceTest extends TestCase
{
    public function testRegisterFailsEmailAlreadyExists()
    {
        $email = 'test@example.com';
        $password = 'Str0ngP@ssw0rd!';

        $userMock = $this->createMock(User::class);

        $repository = $this->createMock(EntityRepository::class);
        $repository->expects($this->once())->method('findOneBy')->willReturn($userMock);
        $em = $this->createMock(EntityManagerInterface::class);
        $em->expects($this->once())->method('getRepository')->willReturn($repository);
        $jwt = $this->createMock(JWTService::class);
        $hasher = $this->createMock(UserPasswordHasherInterface::class);

        $validator = Validation::createValidator();

        $service = new RegistrationService($em, $hasher, $validator,$jwt);

        $result = $service->register($email, $password);

        $this->assertArrayHasKey('error', $result);
        $this->assertEquals(409, $result['code']);
    }

    /**
     * @dataProvider provideInvalidEmailFormats
     */

    public function testRegisterFailsEmailFormatIsInvalid(string $email)
    {
        $password = 'Str0ngP@ssw0rd!';

        $em = $this->createMock(EntityManagerInterface::class);
        $em->expects($this->never())->method('persist');

        $hasher = $this->createMock(UserPasswordHasherInterface::class);
        $hasher->expects($this->never())->method('hashPassword');

        $jwt = $this->createMock(JWTService::class);

        $validator = Validation::createValidator();

        $service = new RegistrationService($em, $hasher, $validator,$jwt);

        $result = $service->register($email, $password);

        $this->assertArrayHasKey('error', $result);
        $this->assertEquals(400, $result['code']);
        $this->assertStringContainsString('email', $result['error']);
    }

    /**
     * @dataProvider provideWrongPasswords
     */
    public function testRegisterFailsPasswordsIsInvalid(string $password)
    {
        $email = 'test@example.com';

        $em = $this->createMock(EntityManagerInterface::class);
        $em->expects($this->never())->method('persist');

        $hasher = $this->createMock(UserPasswordHasherInterface::class);
        $hasher->expects($this->never())->method('hashPassword');

        $jwt = $this->createMock(JWTService::class);

        $validator = Validation::createValidator();
        $service = new RegistrationService($em, $hasher, $validator,$jwt);

        $result = $service->register($email, $password);

        $this->assertArrayHasKey('error', $result);
        $this->assertEquals(400, $result['code']);
    }



    public function testRegisterSuccess()
    {
        $email = 'test@example.com';
        $password = 'Str0ngP@ssw0rd!';

        $repository = $this->createMock(EntityRepository::class);
        $repository->expects($this->once())
            ->method('findOneBy')
            ->willReturn(null);

        $em = $this->createMock(EntityManagerInterface::class);
        $em->expects($this->once())->method('getRepository')->willReturn($repository);
        $em->expects($this->once())->method('persist');
        $em->expects($this->once())->method('flush');

        $hasher = $this->createMock(UserPasswordHasherInterface::class);
        $hasher->expects($this->once())->method('hashPassword')->willReturn('hashed');

        $jwt = $this->createMock(JWTService::class);

        $validator = Validation::createValidator();

        $service = new RegistrationService($em, $hasher, $validator,$jwt);

        $result = $service->register($email, $password);

        $this->assertArrayHasKey('token', $result);
        $this->assertEquals(201, $result['code']);
        $this->assertEquals('test@example.com', $email);
    }
    public static function provideInvalidEmailFormats(): array
    {
        return
        [
            [''],
            ['test'],
            ['test@'],
            ['@example.com'],
            ['test@@example.com'],
            ['test@example'],
            ['test@.com'],
            ['test@exam_ple.com'],
            ['test@-example.com'],
            ['test@example..com'],
        ];
    }

    public static function provideWrongPasswords(): array
    {
        return [
            [''],
            ['1234567'],
            ['Password1'],
            ['Testtest'],
            ['T3stT3st'],
            ['Qwerty123'],
            ['LetMeIn123'],
            ['Iloveyou1'],
            ['Admin2023'],
            ['Summer2022'],
            ['Pa$$w0rd'],
        ];
    }

}
