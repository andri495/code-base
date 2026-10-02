UPDATE loans
SET date = '2026-09-10',
    note = 'Tanggal pinjaman Sutisna (D12) diperbaiki menjadi 10 September 2026; metode tunai'
WHERE id = 'request-sutisna-d12-20260926'
  AND date = '2026-09-26';

INSERT OR IGNORE INTO loans (id, borrower, amount, date, channel, note)
VALUES ('request-makwo-d4-20260924', 'Mak Wo (Farhan D4)', 50000, '2026-09-24', 'cash',
  'Pinjaman Mak Wo (Farhan D4) sesuai permintaan 24 September 2026; metode tunai diasumsikan');
