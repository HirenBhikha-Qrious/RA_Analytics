{% if not var("enable_subscriptions_warehouse")  %}
{{
    config(
        enabled=false
    )
}}
{% else %}
{{
    config(
        alias='customers_dim'
    )
}}
{% endif %}

with customers as
  (
    SELECT *
    FROM {{ ref('int_customers') }}
  )
SELECT

    GENERATE_UUID() as customer_pk,
    c.*
FROM
   customers c
