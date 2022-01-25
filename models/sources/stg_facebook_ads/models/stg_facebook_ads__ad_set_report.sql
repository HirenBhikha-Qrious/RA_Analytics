{% if var("marketing_warehouse_ad_sources") %}
{% if 'facebook_ads' in var("marketing_warehouse_ad_sources") %}

with adapter AS (

    SELECT *
    FROM {{ ref('stg_facebook_ads__ad_adapter') }}

), aggregated AS (

    SELECT
        date_day,
        account_id,
        account_name,
        campaign_id,
        campaign_name,
        ad_set_id,
        ad_set_name,
        sum(clicks) AS clicks,
        sum(impressions) AS impressions,
        sum(spend) AS spend
    FROM adapter
    {{ dbt_utils.group_by(7) }}

)

SELECT *
FROM aggregated

{% else %} {{config(enabled=false)}} {% endif %}
{% else %} {{config(enabled=false)}} {% endif %}