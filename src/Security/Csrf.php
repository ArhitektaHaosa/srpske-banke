<?php
declare(strict_types=1);
namespace SrpskeBanke\Security;
final class Csrf
{
    public static function token(): string
    {
        if (empty($_SESSION['_csrf'])) $_SESSION['_csrf'] = bin2hex(random_bytes(32));
        return $_SESSION['_csrf'];
    }
    public static function field(): string
    {
        return '<input type="hidden" name="_csrf" value="' . sb_h(self::token()) . '">';
    }
    public static function check(?string $token): bool
    {
        $known = $_SESSION['_csrf'] ?? '';
        return is_string($token) && $known !== '' && hash_equals($known, $token);
    }
}
