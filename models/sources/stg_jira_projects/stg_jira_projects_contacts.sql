{% if not var("enable_jira_projects_source") %}
{{
    config(
        enabled=false
    )
}}
{% endif %}

with source as (
  {{ filter_stitch_table(var('stg_jira_projects_stitch_schema'),var('stg_jira_projects_stitch_users_table'),'accountid') }}
),
renamed as
 (
  SELECT
    concat('{{ var('stg_jira_projects_id-prefix') }}',accountid) AS contact_id,
    split(displayname,' ')[safe_offset(0)] AS contact_first_name,
    split(displayname,' ')[safe_offset(1)] AS contact_last_name,
    displayname AS contact_name,
    CAST(NULL AS STRING) AS contact_job_title,
    emailaddress AS contact_email,
    CAST(NULL AS STRING) AS contact_phone,
    CAST(NULL AS STRING) AS contact_mobile_phone,
    CAST(NULL AS STRING) AS contact_address,
    CAST(NULL AS STRING) AS contact_city,
    CAST(NULL AS STRING) AS contact_state,
    CAST(NULL AS STRING) AS contact_country,
    CAST(NULL AS STRING) AS contact_postcode_zip,
    CAST(NULL AS STRING) AS contact_company,
    CAST(NULL AS STRING) AS contact_website,
    CAST(NULL AS STRING) AS contact_company_id,
    CAST(NULL AS STRING) AS contact_owner_id,
    CAST(NULL AS STRING) AS contact_lifecycle_stage,
    cast(null as boolean)         as user_is_contractor,
    case when emailaddress like '%@{{ var('stg_jira_projects_staff_email_domain') }}%' then true else false end as user_is_staff,
    cast(null as int64)           as user_weekly_capacity,
    cast(null as int64)           as user_default_hourly_rate,
    cast(null as int64)           as user_cost_rate,
    active                        as user_is_active,
    cast(null as timestamp) AS contact_created_date,
    cast(null as timestamp) AS contact_last_modified_date
  FROM source
    WHERE concat('{{ var('stg_jira_projects_id-prefix') }}',accountid)  NOT LIKE '%addon%'
  UNION ALL
    SELECT
      concat('{{ var('stg_jira_projects_id-prefix') }}',-999) AS contact_id,
      CAST(NULL AS STRING) AS contact_first_name,
      CAST(NULL AS STRING) AS contact_last_name,
      'Unassigned'  AS contact_name,
      CAST(NULL AS STRING) AS contact_job_title,
      'unassigned@example.com' AS contact_email,
      CAST(NULL AS STRING) AS contact_phone,
      CAST(NULL AS STRING) AS contact_mobile_phone,
      CAST(NULL AS STRING) AS contact_address,
      CAST(NULL AS STRING) AS contact_city,
      CAST(NULL AS STRING) AS contact_state,
      CAST(NULL AS STRING) AS contact_country,
      CAST(NULL AS STRING) AS contact_postcode_zip,
      CAST(NULL AS STRING) AS contact_company,
      CAST(NULL AS STRING) AS contact_website,
      CAST(NULL AS STRING) AS contact_company_id,
      CAST(NULL AS STRING) AS contact_owner_id,
      CAST(NULL AS STRING) AS contact_lifecycle_stage,
      cast(null as boolean)         as user_is_contractor,
      false as user_is_staff,
      cast(null as int64)           as user_weekly_capacity,
      cast(null as int64)           as user_default_hourly_rate,
      cast(null as int64)           as user_cost_rate,
      false                          as user_is_active,
      cast(null as timestamp) AS contact_created_date,
      cast(null as timestamp) AS contact_last_modified_date
    )
    SELECT
     *
    FROM
     renamed
