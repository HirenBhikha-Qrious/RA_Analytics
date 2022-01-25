{% if not var("enable_asana_projects_source") %}
{{
    config(
        enabled=false
    )
}}
{% endif %}

WITH source AS (
  {{ filter_stitch_table(var('stg_asana_projects_stitch_schema'),var('stg_asana_projects_stitch_tasks_table'),'gid') }}
),
renamed AS (
  SELECT
  concat('{{ var('stg_asana_projects_id-prefix') }}',source.gid) as task_id,
  case when replace(JSON_EXTRACT(parent,'$.gid'),'"','') is not null then concat('{{ var('stg_asana_projects_id-prefix') }}',replace(JSON_EXTRACT(parent,'$.gid'),'"','')) end as parent_task_id,
  concat('{{ var('stg_asana_projects_id-prefix') }}',projects.gid) AS project_id,
  concat('{{ var('stg_asana_projects_id-prefix') }}',assignee.gid)  as task_creator_user_id,
  cast (null as string) as task_assignee_user_id,
  name  as task_name,
  cast(null as string) as task_priority,
  case when parent is null then 'Task' else 'Subtask' end as task_type,
  notes as task_description,
  cast(null as string) task_status,
  completed   as task_is_completed,
  completed_at  as task_completed_ts,
  timestamp_diff(completed_at,created_at,HOUR) total_task_hours_to_complete,
  case when cast(null as string) = 'Done' then 1 end as total_delivery_tasks_completed,
  case when cast(null as string) = 'In Progress' then 1 end as total_delivery_tasks_in_progress,
  case when cast(null as string) = 'To Do' then 1 end as total_delivery_tasks_to_do,
  case when cast(null as string) = 'Low' then 1 end as total_delivery_priority_low,
  case when cast(null as string) = 'Medium' then 1 end as total_delivery_priority_medium,
  case when cast(null as string) = 'High' then 1 end as total_delivery_tasks_high,
  case when case when parent is null then 'Task' else 'Subtask' end = 'Task' then 1 end as total_delivery_tasks,
  case when case when parent is null then 'Task' else 'Subtask' end = 'Subtask' then 1 end as total_delivery_subtasks,
  1 as total_issues,
  created_at    as task_created_ts,
  modified_at as task_last_modified_ts
  FROM
    source,
    unnest(projects) projects
  {{ dbt_utils.group_by(24) }}
)
SELECT
  *
FROM
  renamed
