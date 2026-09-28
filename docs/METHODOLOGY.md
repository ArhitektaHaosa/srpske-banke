# Metodologija

Tačnost > brzina > količina.

## Šta jeste podatak

Podatak ulazi na javnu stranu samo kada ima source_id/source_url, effective_from gde važi tarifnik, retrieved_at, verified_at, verification_status.

## Šta nije podatak

- medijski članak kao jedini dokaz trenutne cene
- korisnički komentar
- NULL pretvoren u 0
- NBS reprezentativna naknada predstavljena kao kompletan tarifnik banke

## Statusi

VERIFIED, STALE, PENDING REVIEW, SOURCE CONFLICT, UNAVAILABLE.

Konflikt: "Zvanični izvori trenutno daju različite podatke. Provera u toku."

## Pragovi stale

promotion 1 dan; account fee 7; loan rate 7; digital 30; legal 90.
