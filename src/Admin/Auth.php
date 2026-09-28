<?php
declare(strict_types=1);
namespace SrpskeBanke\Admin;
use SrpskeBanke\Db;
final class Auth
{
    public static function user(): ?array
    {
        $id = $_SESSION['admin_id'] ?? null;
        if (!$id) return null;
        $st = Db::pdo()->prepare('SELECT * FROM admin_users WHERE id = ? AND is_active = 1');
        $st->execute([(int)$id]);
        $row = $st->fetch();
        return $row ?: null;
    }
    public static function roles(): array
    {
        $u = self::user();
        if (!$u) return [];
        $st = Db::pdo()->prepare('SELECT r.slug FROM admin_roles r JOIN admin_user_roles ur ON ur.role_id = r.id WHERE ur.user_id = ?');
        $st->execute([(int)$u['id']]);
        return array_column($st->fetchAll(), 'slug');
    }
    public static function can(string $need): bool
    {
        $roles = self::roles();
        return in_array('super_admin', $roles, true) || in_array($need, $roles, true);
    }
    public static function canEditBank(int $bankId): bool
    {
        if (self::can('editor')) return true;
        $u = self::user();
        if (!$u) return false;
        $st = Db::pdo()->prepare('SELECT 1 FROM admin_bank_permissions WHERE user_id = ? AND bank_id = ?');
        $st->execute([(int)$u['id'], $bankId]);
        return (bool) $st->fetchColumn();
    }
    public static function attempt(string $email, string $password): bool
    {
        self::bootstrapFromEnv();
        $st = Db::pdo()->prepare('SELECT * FROM admin_users WHERE email = ? AND is_active = 1 LIMIT 1');
        $st->execute([$email]);
        $row = $st->fetch();
        if (!$row || !password_verify($password, $row['password_hash'])) return false;
        session_regenerate_id(true);
        $_SESSION['admin_id'] = (int)$row['id'];
        return true;
    }
    public static function logout(): void { unset($_SESSION['admin_id']); }
    public static function bootstrapFromEnv(): void
    {
        $email = sb_env('ADMIN_EMAIL');
        $hash = sb_env('ADMIN_PASSWORD_HASH');
        if ($email === '' || $hash === '') return;
        $pdo = Db::pdo();
        $st = $pdo->prepare('SELECT id FROM admin_users WHERE email = ?');
        $st->execute([$email]);
        $id = $st->fetchColumn();
        if (!$id) {
            $pdo->prepare('INSERT INTO admin_users (email, password_hash, name) VALUES (?,?,?)')->execute([$email, $hash, sb_env('ADMIN_NAME', 'Super admin')]);
            $id = (int)$pdo->lastInsertId();
        }
        $pdo->prepare('INSERT IGNORE INTO admin_user_roles (user_id, role_id) VALUES (?, 1)')->execute([(int)$id]);
    }
}
