{% if not var("enable_facebook_ads_source") or not var("ad_campaigns_only") %}
{{
    config(
        enabled=false
    )
}}
{% endif %}

{% if var("stg_facebook_ads_etl") == 'stitch' %}
WITH source AS (
  {{ filter_stitch_table(var('stg_facebook_ads_stitch_schema'),var('stg_facebook_ads_stitch_ads_table'),'id') }}
),
renamed as (

    select
    concat('{{ var('stg_facebook_ads_id-prefix') }}',id)              as ad_id,
    status      as ad_status,
      cast(null as string)        as ad_type,
      cast(null as string)   as ad_final_urls,
      concat('{{ var('stg_facebook_ads_id-prefix') }}',adset_id) as ad_group_id,
      bid_type as ad_bid_type,
      url_parameters as ad_utm_parameters,
      utm_campaign as ad_utm_campaign,
      utm_content as ad_utm_content,
      utm_medium as ad_utm_medium,
      utm_source as ad_utm_source,
      'Facebook Ads' as ad_network

    from source
)
{% elif var("stg_facebook_ads_etl") == 'segment' %}
with source as (
  {{ filter_segment_table(var('stg_facebook_ads_segment_schema'),var('stg_facebook_ads_segment_ads_table')) }}
),
renamed as (
SELECT
      concat('{{ var('stg_facebook_ads_id-prefix') }}',id)          as ad_id,
      status      as ad_status,
      cast(null as string)        as ad_type,
      cast(null as string)   as ad_final_urls,
      concat('{{ var('stg_facebook_ads_id-prefix') }}',adset_id) as ad_group_id,
      bid_type as ad_bid_type,
      url_parameters as ad_utm_parameters,
      utm_campaign as ad_utm_campaign,
      utm_content as ad_utm_content,
      utm_medium as ad_utm_medium,
      utm_source as ad_utm_source,
      'Facebook Ads' as ad_network
FROM
  source)
{% endif %}
select
 *
from
 renamed
