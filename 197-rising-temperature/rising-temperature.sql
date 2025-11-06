SELECT w1.id
FROM Weather w1
WHERE w1.temperature > (
    SELECT w2.temperature
    FROM Weather w2
    WHERE w2.recordDate = DATEADD(DAY, -1, w1.recordDate)
);
