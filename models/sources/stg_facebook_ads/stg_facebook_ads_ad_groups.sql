{% if not var("enable_facebook_ads_source") or not var("ad_campaigns_only") %}
{{
    config(
        enabled=false
    )
}}
{% endif %}

{% if var("stg_facebook_ads_etl") == 'stitch' %}
WITH source AS (
  {{ filter_stitch_table(var('stg_facebook_ads_stitch_schema'),var('stg_facebook_ads_stitch_ad_groups_table'),'id') }}
),
renamed as (

  SELECT concat('{{ var('stg_facebook_ads_id-prefix') }}',id) as ad_group_id,
         name as ad_group_name,
         effective_status as ad_group_status,
         concat('{{ var('stg_facebook_ads_id-prefix') }}',campaignid) ad_campaign_id,
         targeting as adset_targeting,
         created_time as adset_created_ts,
         end_time as adset_end_ts,
         start_time as adset_start_ts,
         'Facebook Ads' as ad_network
  FROM source

)
{% elif var("stg_facebook_ads_etl") == 'segment' %}
with source as (
  {{ filter_segment_table(var('stg_facebook_ads_segment_schema'),var('stg_facebook_ads_segment_ad_groups_table')) }}
),
renamed as (
  SELECT concat('{{ var('stg_facebook_ads_id-prefix') }}',id) as ad_group_id,
         name as ad_group_name,
         effective_status as ad_group_status,
         concat('{{ var('stg_facebook_ads_id-prefix') }}',campaign_id) ad_campaign_id,
         'Facebook Ads' as ad_network
  FROM source )
{% endif %}
select
 *
from
 renamed
