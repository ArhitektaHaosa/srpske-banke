<?php
declare(strict_types=1);
namespace SrpskeBanke\Domain;
use SrpskeBanke\Db;
use SrpskeBanke\Support\CurrentValue;
final class PromotionRepository
{
    public function publicForBank(int $bankId): array
    {
        $st = Db::pdo()->prepare('SELECT * FROM promotions WHERE bank_id = ?');
        $st->execute([$bankId]);
        return array_values(array_filter($st->fetchAll(), static fn(array $r) => CurrentValue::promotionPublic($r)));
    }
    public function publicAll(): array
    {
        $rows = Db::pdo()->query('SELECT p.*, b.slug AS bank_slug, b.brand_name FROM promotions p JOIN banks b ON b.id = p.bank_id')->fetchAll();
        return array_values(array_filter($rows, static fn(array $r) => CurrentValue::promotionPublic($r)));
    }
    public function allForAdmin(int $bankId): array
    {
        $st = Db::pdo()->prepare('SELECT * FROM promotions WHERE bank_id = ? ORDER BY id DESC');
        $st->execute([$bankId]);
        return $st->fetchAll();
    }
    public function toggle(int $id, bool $enabled): void
    {
        Db::pdo()->prepare('UPDATE promotions SET is_enabled = ? WHERE id = ?')->execute([$enabled ? 1 : 0, $id]);
    }
}
