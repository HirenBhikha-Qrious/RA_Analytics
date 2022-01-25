{% if not var("enable_looker_usage_source") %}
{{
    config(
        enabled=false
    )
}}
{% endif %}
WITH source AS (

    select
      *
    from
      `ra-development.fivetran_email.usage_stats`

),
renamed as (
select * from (
SELECT
  concat('looker-',coalesce(name,user_name)) AS contact_id,
  split(coalesce(name,user_name),' ')[safe_offset(0)] AS contact_first_name,
  split(coalesce(name,user_name),' ')[safe_offset(1)] AS contact_last_name,
  coalesce(name,user_name)  AS contact_name,
  cast(null as string) AS contact_job_title,
  cast(null as string) AS contact_email,
  cast(null as string)  AS contact_phone,
  cast(null as string)  AS contact_phone_mobile,
  cast(null as string)  as contact_address,
  cast(null as string)  as contact_city,
  cast(null as string)  as contact_state,
  cast(null as string)  as contact_country,
  cast(null as string)  as contact_postcode_zip,
  cast(null as string)  as contact_company,
  cast(null as string)  as contact_website,
  cast(null as string) AS contact_company_id,
  cast(null as string)  as contact_owner_id,
  cast(null as string)  as contact_lifecycle_stage,
  case when split(coalesce(name,user_name),' ')[safe_offset(0)] in ('Olivier','Tomek') then true else false end as user_is_contractor,
  case when split(coalesce(name,user_name),' ')[safe_offset(0)] in ('Mark','Rob','Olivier','Mike','Lewis','Craig','Tomek') then true else false end as user_is_staff,
  cast(null as int64)                   as user_weekly_capacity,
  cast(null as int64)                as user_default_hourly_rate,
  cast(null as int64)                         as user_cost_rate,
  cast(null as boolean)                          as user_is_active,
  min(timestamp(history_created_time)) over (partition by coalesce(name,user_name)) AS contact_created_date,
  max(timestamp(history_created_time)) over (partition by coalesce(name,user_name)) as contact_last_modified_date
    FROM source )
    group by 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26)
select * from renamed
