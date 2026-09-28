<?php
declare(strict_types=1);
namespace SrpskeBanke\Domain;
use SrpskeBanke\Db;
final class ProductRepository
{
    public function publishedForBank(int $bankId, ?string $category = null): array
    {
        $sql = 'SELECT p.*, t.slug AS type_slug, t.name AS type_name, t.category FROM products p JOIN product_types t ON t.id = p.product_type_id WHERE p.bank_id = ? AND p.is_published = 1';
        $args = [$bankId];
        if ($category !== null) { $sql .= ' AND t.category = ?'; $args[] = $category; }
        $st = Db::pdo()->prepare($sql);
        $st->execute($args);
        return $st->fetchAll();
    }
    public function publishedCards(int $bankId): array
    {
        $st = Db::pdo()->prepare('SELECT * FROM cards WHERE bank_id = ? AND is_published = 1');
        $st->execute([$bankId]);
        return $st->fetchAll();
    }
    public function fees(int $bankId): array
    {
        $st = Db::pdo()->prepare('SELECT f.*, ft.name AS fee_type_name FROM fees f JOIN fee_types ft ON ft.id = f.fee_type_id WHERE f.bank_id = ? AND f.is_published = 1');
        $st->execute([$bankId]);
        return $st->fetchAll();
    }
    public function digital(int $bankId): ?array
    {
        $st = Db::pdo()->prepare('SELECT * FROM digital_services WHERE bank_id = ? AND is_published = 1 LIMIT 1');
        $st->execute([$bankId]);
        $row = $st->fetch();
        return $row ?: null;
    }
    public function ips(int $bankId): ?array
    {
        $st = Db::pdo()->prepare('SELECT * FROM ips_services WHERE bank_id = ? AND is_published = 1 LIMIT 1');
        $st->execute([$bankId]);
        $row = $st->fetch();
        return $row ?: null;
    }
}
