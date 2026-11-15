$ sf apex run --file script/prova.apex
$ sf apex run test --class-names RiepilogoTest \
    --result-format human --code-coverage --wait 10
$ sf apex tail log --color
$ sf data query \
    --query "SELECT Name FROM Account LIMIT 5"
