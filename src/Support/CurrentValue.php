<?php
declare(strict_types=1);

namespace SrpskeBanke\Support;

final class CurrentValue
{
    public static function isCurrent(?string $from, ?string $to, ?string $today = null): bool
    {
        $today = $today ?? date('Y-m-d');
        if ($from !== null && $from > $today) {
            return false;
        }
        if ($to !== null && $to < $today) {
            return false;
        }
        return true;
    }

    public static function promotionPublic(array $promo, ?string $now = null): bool
    {
        if (empty($promo['is_enabled'])) {
            return false;
        }
        $nowDt = $now ?? date('Y-m-d H:i:s');
        $today = substr($nowDt, 0, 10);
        if (!empty($promo['start_at']) && $promo['start_at'] > $nowDt) {
            return false;
        }
        if (!empty($promo['end_at']) && $promo['end_at'] < $nowDt) {
            return false;
        }
        if (!empty($promo['valid_from']) && $promo['valid_from'] > $today) {
            return false;
        }
        if (!empty($promo['valid_until']) && $promo['valid_until'] < $today) {
            return false;
        }
        return true;
    }
}
