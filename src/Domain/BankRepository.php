<?php
declare(strict_types=1);
namespace SrpskeBanke\Domain;
use SrpskeBanke\Db;
final class BankRepository
{
    public function allActive(): array
    {
        $st = Db::pdo()->prepare('SELECT * FROM banks WHERE status = ? ORDER BY brand_name ASC');
        $st->execute(['active']);
        return $st->fetchAll();
    }
    public function findBySlug(string $slug): ?array
    {
        $st = Db::pdo()->prepare('SELECT * FROM banks WHERE slug = ? LIMIT 1');
        $st->execute([$slug]);
        $row = $st->fetch();
        return $row ?: null;
    }
    public function search(string $q): array
    {
        $norm = mb_strtolower(trim($q), 'UTF-8');
        if ($norm === '') return $this->allActive();
        $like = '%' . $norm . '%';
        $sql = 'SELECT DISTINCT b.* FROM banks b LEFT JOIN bank_aliases a ON a.bank_id = b.id
                WHERE b.status = ? AND (LOWER(b.brand_name) LIKE ? OR LOWER(b.legal_name) LIKE ? OR LOWER(b.slug) LIKE ? OR a.alias_norm LIKE ?)
                ORDER BY b.brand_name';
        $st = Db::pdo()->prepare($sql);
        $st->execute(['active', $like, $like, $like, $like]);
        return $st->fetchAll();
    }
    public function countActive(): int
    {
        return (int) Db::pdo()->query("SELECT COUNT(*) FROM banks WHERE status = 'active'")->fetchColumn();
    }
}
