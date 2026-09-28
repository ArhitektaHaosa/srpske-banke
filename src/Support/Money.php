<?php
declare(strict_types=1);

namespace SrpskeBanke\Support;

final class Money
{
    public static function format(?string $amount, string $currency = 'RSD'): string
    {
        if ($amount === null || $amount === '') {
            return sb_missing();
        }
        $n = (float) $amount;
        $formatted = number_format($n, $n == floor($n) ? 0 : 2, ',', '.');
        return $formatted . ' ' . $currency;
    }

    public static function computeFee(?float $baseAmount, ?float $fixed, ?float $percent, ?float $minimum, ?float $maximum): array
    {
        $parts = [];
        $total = 0.0;
        $complete = true;
        if ($fixed === null && $percent === null) {
            return ['total' => null, 'complete' => false, 'parts' => ['Naknada nije verifikovana']];
        }
        if ($fixed !== null) {
            $total += $fixed;
            $parts[] = 'fiksno';
        }
        if ($percent !== null) {
            if ($baseAmount === null) {
                $complete = false;
                $parts[] = 'procenat čeka iznos';
            } else {
                $total += $baseAmount * ($percent / 100);
            }
        }
        if ($complete && $minimum !== null && $total < $minimum) {
            $total = $minimum;
        }
        if ($complete && $maximum !== null && $total > $maximum) {
            $total = $maximum;
        }
        return ['total' => $complete ? $total : null, 'complete' => $complete, 'parts' => $parts];
    }
}
