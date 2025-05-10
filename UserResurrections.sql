SET sql_mode = '';
SELECT 
	s1.cancelled_date AS original_canceled_date,
    s2.cancelled_date AS resurrected_canceled_date,
    s1.created_date AS original_created_date,
	s2.created_date AS resurrected_created_date,
    s1.end_date AS original_end_date,
    s2.end_date AS resurrected_end_date,
    s1.next_charge_date AS original_next_charge_date,
    s2.next_charge_date AS resurrected_next_charge_date,
    CASE
		WHEN s1.subscription_type = 0 THEN 'monthly'
        WHEN s1.subscription_type = 2 THEN 'annually'
        WHEN s1.subscription_type = 3 THEN 'lifetime'
	END AS original_subscription_plan,
	CASE
		WHEN s2.subscription_type = 0 THEN 'monthly'
        WHEN s2.subscription_type = 2 THEN 'annually'
        WHEN s2.subscription_type = 3 THEN 'lifetime'
	END AS resurrected_subscription_plan,
	DATEDIFF(CAST(s2.created_date AS DATE), CAST(s1.end_date AS DATE)) AS days_to_resurrection,
    s1.student_id,
    s1.subscription_id AS original_subscription_ID,
    s2.subscription_id AS resurrected_subscription_ID
FROM 
	customer_churn.subscriptions s1
JOIN
	customer_churn.subscriptions s2 
ON
	(s1.student_id = s2.student_id 
    AND s1.subscription_id != s2.subscription_id
    AND s2.subscription_id > s1.subscription_id
    AND s2.created_date > s1.created_date)
WHERE
	s1.state = 3
    AND
    DATEDIFF(CAST(s2.created_date AS DATE), CAST(s1.end_date AS DATE)) > 1
GROUP BY
	s1.student_id;