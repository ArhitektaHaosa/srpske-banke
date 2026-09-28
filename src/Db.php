<?php
declare(strict_types=1);

namespace SrpskeBanke;

use PDO;
use PDOException;

final class Db
{
    private static ?PDO $pdo = null;

    public static function pdo(): PDO
    {
        if (self::$pdo instanceof PDO) {
            return self::$pdo;
        }
        $host = sb_env('DB_HOST', '127.0.0.1');
        $port = sb_env('DB_PORT', '3306');
        $name = sb_env('DB_NAME', 'srpske_banke');
        $user = sb_env('DB_USER', '');
        $pass = sb_env('DB_PASS', '');
        $charset = sb_env('DB_CHARSET', 'utf8mb4');
        $dsn = "mysql:host={$host};port={$port};dbname={$name};charset={$charset}";
        try {
            self::$pdo = new PDO($dsn, $user, $pass, [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
            ]);
        } catch (PDOException $e) {
            if (Config::isDebug()) {
                throw $e;
            }
            http_response_code(500);
            echo 'Baza nije dostupna.';
            exit;
        }
        return self::$pdo;
    }
}
