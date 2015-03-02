if defined?(ActiveRecord)
  ActiveSupport::Notifications.subscribe 'sql.active_record' do |name, start, finish, id, payload|
    if payload[:sql].downcase.match(/(select|update|insert|delete)(.+)/i)
      table, action = ServiceTemplate::ActiveRecordStats.extract_sql_content(payload[:sql])
    end

    if table
      ServiceTemplate::Stats.emitter.timing(
        "sql.query_time",
      (finish - start) * 1000)

      ServiceTemplate::Stats.emitter.timing(
        "sql.table.#{table}.#{action.downcase}.query_time",
      (finish - start) * 1000)
    end
  end
end
