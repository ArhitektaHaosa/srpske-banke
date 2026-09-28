<?php
declare(strict_types=1);

namespace SrpskeBanke\Domain;

final class Calculator
{
    public static function monthly(array $usage, array $prices): array
    {
        $lines = [];
        $total = 0.0;
        $complete = true;

        $add = static function (?float $unit, int $qty, string $label) use (&$lines, &$total, &$complete): void {
            if ($qty <= 0) {
                return;
            }
            if ($unit === null) {
                $complete = false;
                $lines[] = ['label' => $label, 'qty' => $qty, 'unit' => null, 'sum' => null, 'note' => 'Nema dovoljno pouzdanih podataka — stavka nije uračunata kao 0.'];
                return;
            }
            $sum = $unit * $qty;
            $total += $sum;
            $lines[] = ['label' => $label, 'qty' => $qty, 'unit' => $unit, 'sum' => $sum, 'note' => null];
        };

        $pkg = $prices['package'] ?? null;
        if ($pkg === null) {
            $complete = false;
            $lines[] = ['label' => 'Mesečno održavanje paketa', 'qty' => 1, 'unit' => null, 'sum' => null, 'note' => 'Nema dovoljno pouzdanih podataka — paket nije uračunat kao 0 RSD.'];
        } else {
            $add((float) $pkg, 1, 'Mesečno održavanje paketa');
        }

        $unit = static function (array $prices, string $key): ?float {
            if (!array_key_exists($key, $prices) || $prices[$key] === null || $prices[$key] === '') {
                return null;
            }
            return (float) $prices[$key];
        };

        $add($unit($prices, 'ebanking_transfer'), (int) ($usage['ebanking_transfers'] ?? 0), 'E-banking transfer');
        $add($unit($prices, 'instant'), (int) ($usage['instant_transfers'] ?? 0), 'Instant transfer');
        $add($unit($prices, 'branch'), (int) ($usage['branch_orders'] ?? 0), 'Nalog na šalteru');
        $add($unit($prices, 'atm_own'), (int) ($usage['atm_own'] ?? 0), 'ATM sopstvene banke');
        $add($unit($prices, 'atm_other'), (int) ($usage['atm_other'] ?? 0), 'ATM druge banke');

        return [
            'lines' => $lines,
            'monthly' => $complete ? $total : null,
            'yearly' => $complete ? $total * 12 : null,
            'complete' => $complete,
        ];
    }
}
