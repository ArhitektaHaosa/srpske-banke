<?php
declare(strict_types=1);
namespace SrpskeBanke\Import;
use SrpskeBanke\Db;
final class DiffEngine
{
    public function record(string $adapter, array $changes): int
    {
        $pdo = Db::pdo();
        $pdo->prepare('INSERT INTO imports (adapter, started_at, finished_at, status) VALUES (?, NOW(), NOW(), ?)')->execute([$adapter, 'completed']);
        $importId = (int) $pdo->lastInsertId();
        $ins = $pdo->prepare('INSERT INTO import_changes (import_id, bank_id, entity_type, field_name, old_value, new_value, source_url, review_status) VALUES (?,?,?,?,?,?,?,?)');
        foreach ($changes as $c) {
            if (($c['old'] ?? null) === ($c['new'] ?? null)) continue;
            $ins->execute([$importId, $c['bank_id'] ?? null, $c['entity'] ?? 'unknown', $c['field'] ?? 'value', $c['old'] ?? null, $c['new'] ?? null, $c['url'] ?? null, 'pending']);
        }
        return $importId;
    }
    public function review(int $changeId, string $decision): void
    {
        if (!in_array($decision, ['approved','rejected','edited','kept_old'], true)) return;
        Db::pdo()->prepare('UPDATE import_changes SET review_status = ?, reviewed_at = NOW() WHERE id = ?')->execute([$decision, $changeId]);
    }
}
