<?php
declare(strict_types=1);

namespace SrpskeBanke;

final class Config
{
    public static function appName(): string
    {
        return sb_env('APP_NAME', 'Srpske banke');
    }

    public static function appUrl(): string
    {
        return rtrim(sb_env('APP_URL', ''), '/');
    }

    public static function isDebug(): bool
    {
        return sb_env('APP_DEBUG', '0') === '1';
    }

    public static function remarkEnabled(): bool
    {
        return sb_env('REMARK42_ENABLED', '0') === '1';
    }
}
