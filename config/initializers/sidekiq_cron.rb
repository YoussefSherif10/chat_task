jobs = [
  {
    'name' => 'update_messages_count',
    'class' => 'UpdateMessagesCountJob',
    'cron' => '*/30 * * * *',
  },
  {
    'name' => 'update_chats_count',
    'class' => 'UpdateChatsCountJob',
    'cron' => '*/30 * * * *',
  }
]
Sidekiq::Cron::Job.load_from_array(jobs)
