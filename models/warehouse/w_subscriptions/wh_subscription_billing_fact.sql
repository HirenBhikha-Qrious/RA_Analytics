{% if not var("enable_stripe_subscriptions_source")  %}
{{
    config(
        enabled=false
    )
}}
{% else %}
{{
    config(
        alias='subscription_billing_fact'
    )
}}
{% endif %}

WITH subscriptions AS
  (
  SELECT *
  FROM   {{ ref('wh_subscriptions_fact') }}
),
customers as (
  SELECT *
  FROM   {{ ref('wh_customers_dim') }}
),
subscription_billing as (
  SELECT *
  FROM {{ ref('int_subscription_billing') }}
)
SELECT
   GENERATE_UUID() as subscription_billing_pk,
   c.customer_pk,
   s.subscription_pk,
   b.*
FROM
   subscription_billing b
JOIN
   customers c
ON b.customer_id = c.customer_alternative_id
JOIN
   subscriptions s
ON
   b.subscription_id = s.subscription_id
