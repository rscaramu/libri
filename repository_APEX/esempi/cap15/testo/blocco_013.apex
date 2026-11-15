insert new Task(Subject = 'Richiamare',
    WhatId = [SELECT Id FROM Account
        WHERE Name = 'Tecno Sud' LIMIT 1].Id);
Task t = [SELECT Subject, What.Name, What.Type
    FROM Task WHERE Subject = 'Richiamare'
    ORDER BY CreatedDate DESC LIMIT 1];
System.debug(t.What.Name);
System.debug(t.What.Type);
