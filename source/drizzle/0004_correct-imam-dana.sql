UPDATE payments
SET paid_date = '2026-09-11',
    channel = 'DANA',
    note = 'Imam (D5) setor melalui DANA pada 11 September 2026'
WHERE id = 'seed-D5'
  AND resident_id = 'D5'
  AND amount = 40000
  AND paid_date = '2026-08-01';

DELETE FROM transfers
WHERE id = 'seed-dana-60k'
  AND amount = 60000
  AND from_channel = 'cash'
  AND to_channel = 'DANA';
