<?php
// src/Security/ApiTokenAuthenticator.php
namespace App\Security;


use App\Repository\UserRepository;
use PHPUnit\Util\Json;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Security\Core\Exception\AuthenticationException;
use Symfony\Component\Security\Core\Authentication\Token\TokenInterface;

use Symfony\Component\Security\Http\Authenticator\AbstractAuthenticator;
use Symfony\Component\Security\Http\Authenticator\Passport\Badge\UserBadge;
use Symfony\Component\Security\Http\Authenticator\Passport\Passport;
use Symfony\Component\Security\Http\Authenticator\Passport\SelfValidatingPassport;

class APIAuthenticator extends AbstractAuthenticator
{
    private UserRepository $userRepository;

    // <-- Injection du UserRepository
    public function __construct(UserRepository $userRepository)
    {
        $this->userRepository = $userRepository;
    }


    public function supports(Request $request): ?bool
    {
        $auth = $request->headers->get('Authorization', '');
        // 1. On vérifie qu’on a un header et qu’il commence bien par "Bearer "
        return str_starts_with($auth, 'Bearer ');
    }

    public function authenticate(Request $request): Passport
    {
        // 1) Récupère l'en-tête Authorization
        $authHeader = $request->headers->get('Authorization', '');

        $token = substr($authHeader, 7);

        return new SelfValidatingPassport(
            new UserBadge(
                $token,
                fn(string $apiToken) => $this->userRepository->findOneBy(['apiToken' => $apiToken])
            )
        );
    }


    public function onAuthenticationSuccess(Request $request, TokenInterface $token, string $firewallName): ?Response
    {
       return null;
    }

    public function onAuthenticationFailure(Request $request, AuthenticationException $exception): ?Response
    {
        return new JsonResponse([
            'message' => $exception->getMessage()
        ], Response::HTTP_UNAUTHORIZED);
    }
}
