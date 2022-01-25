{% if not var("enable_harvest_projects_source") %}
{{
    config(
        enabled=false
    )
}}
{% endif %}

with source as (
  {{ filter_stitch_table(var('stg_harvest_projects_stitch_schema'),var('stg_harvest_projects_stitch_users_table'),'id') }}

),
renamed as (
  SELECT
  concat('{{ var('stg_harvest_projects_id-prefix') }}',cast(id as string)) AS contact_id,
  first_name AS contact_first_name,
  last_name AS contact_last_name,
  case when concat(first_name,' ',last_name) = ' ' then email else concat(first_name,' ',last_name) end AS contact_name,
  cast(null as string) AS contact_job_title,
  email AS contact_email,
  replace(replace(replace(replace(telephone,'+','00'),' ',''),')',''),'(','')  AS contact_phone,
  replace(replace(replace(replace(telephone,'+','00'),' ',''),')',''),'(','')  AS contact_phone_mobile,
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
  is_contractor                      as user_is_contractor,
  true                               as user_is_staff,
  weekly_capacity                    as user_weekly_capacity,
  default_hourly_rate                as user_default_hourly_rate,
  cost_rate                          as user_cost_rate,
  is_active                          as user_is_active,
  min(updated_at) over (partition by id order by updated_at) AS contact_created_date,
  updated_at as contact_last_modified_date
FROM
  source
)
SELECT
  *
FROM
  renamed
