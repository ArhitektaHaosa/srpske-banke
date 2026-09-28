<?php
declare(strict_types=1);
namespace SrpskeBanke\Admin;
use SrpskeBanke\Db;
final class Audit
{
    public static function log(string $action, ?string $entityType = null, ?int $entityId = null, ?string $old = null, ?string $new = null, ?string $reason = null): void
    {
        $user = Auth::user();
        Db::pdo()->prepare('INSERT INTO audit_logs (user_id, action, entity_type, entity_id, old_value, new_value, reason, ip) VALUES (?,?,?,?,?,?,?,?)')
            ->execute([$user['id'] ?? null, $action, $entityType, $entityId, $old, $new, $reason, $_SERVER['REMOTE_ADDR'] ?? null]);
    }
}
