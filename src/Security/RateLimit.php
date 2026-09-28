<?php
declare(strict_types=1);
namespace SrpskeBanke\Security;
final class RateLimit
{
    public static function hit(string $bucket, int $limit, int $windowSeconds = 60): bool
    {
        $dir = dirname(__DIR__, 2) . '/storage/cache';
        if (!is_dir($dir)) @mkdir($dir, 0770, true);
        $ip = $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
        $key = $dir . '/rl_' . hash('sha256', $bucket . '|' . $ip) . '.json';
        $now = time();
        $data = ['t' => $now, 'n' => 0];
        if (is_file($key)) {
            $raw = json_decode((string) file_get_contents($key), true);
            if (is_array($raw) && ($now - (int)($raw['t'] ?? 0)) < $windowSeconds) $data = $raw;
        }
        $data['n'] = (int)($data['n'] ?? 0) + 1;
        if ($data['n'] === 1) $data['t'] = $now;
        file_put_contents($key, json_encode($data), LOCK_EX);
        return $data['n'] <= $limit;
    }
}
