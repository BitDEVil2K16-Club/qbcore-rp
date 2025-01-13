local Translations = {
    error = {
        job_failed = 'Failed to apply for %{value}',
        item_failed = 'Failed to recieve %{value}',
        not_enough = 'You do not have enough money for this',
    },
    success = {
        recieved_license = 'You have recived your %{value} for $50'
    },
    info = {
        new_job = 'Congratulations on your new job! (%{job})',
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

return Lang
