<?php
// src/Security/ApiTokenAuthenticator.php
namespace App\Security;


use App\Repository\UserRepository;
use App\Service\JWTService;
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
    private JWTService $jwtService;

    // <-- Injection du UserRepository
    public function __construct(
        UserRepository $userRepository,
        JWTService $jwtService
    ) {
        $this->userRepository = $userRepository;
        $this->jwtService = $jwtService;
    }


    public function supports(Request $request): ?bool
    {
        $auth = $request->headers->get('Authorization', '');
        return str_starts_with($auth, 'Bearer ');
    }

    public function authenticate(Request $request): Passport
    {
        $authHeader = $request->headers->get('Authorization', '');

        $token = substr($authHeader, 7);

        // Vérification de la forme
        if (!$this->jwtService->isValid($token)) {
            throw new AuthenticationException('Token JWT invalide (mal formé).');
        }

        // Vérification expiration
        if ($this->jwtService->isExpired($token)) {
            throw new AuthenticationException('Token JWT expiré.');
        }

        // Vérification de la signature
        if (!$this->jwtService->check($token)) {
            throw new AuthenticationException('Signature JWT invalide.');
        }

        // Récupération des infos utilisateur depuis le token
        $payload = $this->jwtService->getPayload($token);

        if (!isset($payload['email'])) {
            throw new AuthenticationException('Le token ne contient pas d\'email.');
        }

        return new SelfValidatingPassport(
            new UserBadge($payload['email'], function ($userIdentifier) {
                $user = $this->userRepository->findOneBy(['email' => $userIdentifier]);
                if (!$user) {
                    throw new AuthenticationException('Utilisateur non trouvé.');
                }
                return $user;
            })
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
