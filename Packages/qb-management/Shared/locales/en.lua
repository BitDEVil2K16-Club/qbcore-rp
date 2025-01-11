local Translations = {
    job_options = {
        ['employees'] = 'Manage Employees',
        ['hire'] = 'Hire Employee',
        ['stash'] = 'Open Storage',
        ['wardrobe'] = 'Change Clothes',
        ['grade'] = 'Grade: ',
        ['fire'] = 'Fire Employee',
        ['cid'] = 'Citizen ID: ',
        ['return'] = 'Return',
        ['no_employees'] = 'No Employees Found',
        ['no_nearby'] = 'No one nearby',
    },
    target = {
        ['label'] = 'Boss Menu',
    },
    gang_options = {
        ['members'] = 'Manage Members',
        ['recruit'] = 'Recruit Member',
        ['stash'] = 'Open Storage',
        ['wardrobe'] = 'Change Clothes',
        ['grade'] = 'Grade: ',
        ['fire'] = 'Fire',
        ['hire'] = 'Recruit Members - ',
        ['cid'] = 'Citizen ID: ',
        ['return'] = 'Return',
    },
    targetgang = {
        ['label'] = 'Gang Menu',
    },
    success = {
        ['e_hired'] = 'Employee hired!',
        ['e_hiredt'] = 'You have been hired!',
        ['e_fired'] = 'Employee fired!',
        ['e_updated'] = 'Employee updated!',
        ['e_updatedt'] = 'You have been promoted!',
        ['recruited'] = 'Member recruited!',
        ['recruitedt'] = 'You have been promoted!',
        ['removed'] = 'Member removed!',
        ['updated'] = 'Member updated!',
    },
    error = {
        ['e_fired'] = 'You have been fired!',
        ['removed'] = 'You have been removed from your gang!',
        ['demoted'] = 'You have been demoted!',
        ['unauthorized'] = 'Not authorized!',
        ['unavailable'] = 'Citizen unavailable!',
        ['failed'] = 'Action failed!',
    }
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})

return Lang
